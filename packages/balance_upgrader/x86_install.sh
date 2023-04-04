#!/bin/sh

PACKAGE=$1

ENCRYPT_RDISK_SIZE=95

if [ "$BUILD_MODEL" = "bs" ] ; then
# all firmwares before 4.9 requires 16384 or 24576 as disk size
# firmware 4.9 seems to be ok with other values
# x86_64 needs larger rootddisk disk space
	if [ "$PL_BUILD_ARCH" = "x86_64" ]; then
		DISK_SIZE=100256
	else
		DISK_SIZE=35840
	fi
elif [ "$BUILD_MODEL" = "fh" ] ; then
	# in MB
	ENCRYPT_RDISK_SIZE=60
	# DISK_SIZE (firmware image size) has to be larger than ENCRYPT_RDISK_SIZE in kB
	DISK_SIZE=75840
	NO_BOOTLOADER_UPGRADE="y"
else
	# ramdisk size for all other platform
	DISK_SIZE=16384
fi

if [ "${BLD_CONFIG_SECURITY_APPARMOR_UTILS}" = "y" ]; then
	ENCRYPT_RDISK_SIZE=$((ENCRYPT_RDISK_SIZE + 8))
	DISK_SIZE=$((DISK_SIZE + 24576))
fi

. ${PACKAGESDIR}/common/common_functions
. $PACKAGESDIR/common/upgrader_functions

FETCHEDDIR=${FETCHDIR}/$PACKAGE/x86

MCU_FIRMWARE_BUILD_DIR=${FETCHDIR}/mcu_firmware/build

abspath=`pwd`

cd ${FETCHEDDIR}
rm -rf ramdisk
mkdir -p ramdisk
tar xzf ramdisk.tar.gz -C ramdisk
cd $abspath

BUILD_NUMBER=`cat plb.bno`

HOST_TOOLS_DIR=$abspath/tools/host/bin

GENEXT2FS=$HOST_TOOLS_DIR/genext2fs
GENIMAGE_BIN=$HOST_TOOLS_DIR/genimage
FIWM_BIN=$HOST_TOOLS_DIR/fiwm
VERISIGN_BIN=$HOST_TOOLS_DIR/peplink_sign_firmware

dstpath=$abspath/images

FW_VERSION=${abspath}/${MNT}/etc/software-release
VERSION=`cat $FW_VERSION`
#bootdata1.bin is bzImage
#bootdata2.bin is encoded ramdisk image
#bootdata.bin is crypted bzImage + ramdisk image
CFBZIMAGE=bootdata1.bin
CFRAMDISKIMAGE=bootdata2.bin
CFBOOTDATA=bootdata.bin
BZIMAGE=$dstpath/bzImage
RDISKIMAGE=$dstpath/rdisk.gz
ENCRYPT_RDISK=$dstpath/encrypt.fs
sudo_cmd=sudo

KERNEL_IMAGE=$BZIMAGE

if [ ! -f ${BZIMAGE} ]; then
echo "${BZIMAGE} not found"
exit 1
fi

if [ ! -f ${RDISKIMAGE} ]; then
echo "${RDISKIMAGE} not found"
exit 1
fi

if [ ! -f ${FW_VERSION} ]; then
echo "${FW_VERSION} not found"
exit 1
fi

if [ "$BLD_CONFIG_ENCRYPT_RDISK" = "y" ]; then
	CRYPT_DEV_NAME="${PL_BUILD_ARCH}_`date +%s`"

	rm -rf ${FETCHEDDIR}/encrypt.fs

	if ! dd if=/dev/zero bs=1M count=$ENCRYPT_RDISK_SIZE of=${FETCHEDDIR}/encrypt.fs ; then
		echo_error "Failed to create encryption file."
		exit 1
	fi
	if ! $sudo_cmd cryptsetup luksFormat --type luks1 --batch-mode -i 100 --key-size 256 ${FETCHEDDIR}/encrypt.fs $ENCRYPT_RDISK_KEY ; then
		echo_error "Failed to luksFormat encryption file."
		exit 1
	fi
	if ! $sudo_cmd cryptsetup luksOpen ${FETCHEDDIR}/encrypt.fs $CRYPT_DEV_NAME -d $ENCRYPT_RDISK_KEY ; then
		echo_error "Failed to luksOpen encryption file."
		exit 1
	fi

	if ! $sudo_cmd mke2fs -j /dev/mapper/${CRYPT_DEV_NAME} ; then
		echo_error "Failed to create file system"
		exit 1
	fi

	mkdir -p ${FETCHEDDIR}/encryptfs_mnt

	if ! $sudo_cmd mount /dev/mapper/${CRYPT_DEV_NAME} ${FETCHEDDIR}/encryptfs_mnt ; then
		echo_error "Failed to mount filesystem"
		exit 1
	fi

	if ! $sudo_cmd cp -f ${BZIMAGE} ${FETCHEDDIR}/encryptfs_mnt/${CFBZIMAGE} ; then
		echo_error "Failed to install ${BZIMAGE}"
		exit 1
	fi
	if ! $sudo_cmd cp -f ${RDISKIMAGE} ${FETCHEDDIR}/encryptfs_mnt/${CFRAMDISKIMAGE} ; then
		echo_error "Failed to install ${RDISKIMAGE}"
		exit 1
	fi

	if ! $sudo_cmd cp -f ${FW_VERSION} ${FETCHEDDIR}/encryptfs_mnt/ ; then
		echo_error "Failed to install ${FW_VERSION}"
		exit 1
	fi

	sync

	$sudo_cmd umount ${FETCHEDDIR}/encryptfs_mnt
	$sudo_cmd cryptsetup luksClose $CRYPT_DEV_NAME

	ln -sf ${abspath}/${FETCHEDDIR}/encrypt.fs $ENCRYPT_RDISK

	if [ ! -f ${ENCRYPT_RDISK} ]; then
		echo "${BZIMAGE} not found"
		exit 1
	fi

	cp -f ${ENCRYPT_RDISK} ${FETCHEDDIR}/ramdisk/${CFBOOTDATA}

	if [ "$NO_BOOTLOADER_UPGRADE" != "y" ]; then
		cp -f ${FETCHEDDIR}/bootloader/fa ${FETCHEDDIR}/ramdisk/
		cp -f ${FETCHEDDIR}/bootloader/fb ${FETCHEDDIR}/ramdisk/
	fi
else
	cp -f ${BZIMAGE} ${FETCHEDDIR}/ramdisk/${CFBZIMAGE}
	cp -f ${RDISKIMAGE} ${FETCHEDDIR}/ramdisk/${CFRAMDISKIMAGE}
fi

cp -f ${FW_VERSION} ${FETCHEDDIR}/ramdisk/
cp -f ${FETCHEDDIR}/default ${FETCHEDDIR}/ramdisk/sbin/
cp -f ${FETCHEDDIR}/hdefault ${FETCHEDDIR}/ramdisk/sbin/

if [ "$BLD_CONFIG_LIBREMOTESIM" = "y" -o "$BLD_CONFIG_ST_FIRMWARE" = "y" ]; then
	cp -f ${FETCHDIR}/${PACKAGE}/scripts/sbin/stdefault ${FETCHEDDIR}/ramdisk/sbin/
	cp -f ${FETCHDIR}/${PACKAGE}/scripts/sbin/stdefault_multi ${FETCHEDDIR}/ramdisk/sbin/
	if [ -d $MCU_FIRMWARE_BUILD_DIR/st ]; then
		cp -af $MCU_FIRMWARE_BUILD_DIR/st ${FETCHEDDIR}/ramdisk/
	fi
fi

cp -f ${FETCHDIR}/${PACKAGE}/scripts/sbin/stdefault_ex ${FETCHEDDIR}/ramdisk/sbin/

if [ "$BUILD_TARGET" = "fhvm" ]; then
	cp -f ${FETCHEDDIR}/grub.cfg.dfl ${FETCHEDDIR}/ramdisk/grub.cfg.dfl
	cp -f ${FETCHEDDIR}/menu.dfl.fhvm ${FETCHEDDIR}/ramdisk/menu.dfl
elif [ "${BUILD_TARGET}" = "apx" ]; then
	cp -f ${FETCHEDDIR}/grub.cfg.dfl.apx ${FETCHEDDIR}/ramdisk/grub.cfg.dfl
elif [ "${BUILD_TARGET}" = "vbal"  ]; then
	cp -f ${FETCHEDDIR}/grub.cfg.dfl.vbal ${FETCHEDDIR}/ramdisk/grub.cfg.dfl
elif [ "$BLD_CONFIG_ENCRYPT_RDISK" = "y" ]; then
	cp -f ${FETCHEDDIR}/grub.cfg.dfl.x86 ${FETCHEDDIR}/ramdisk/grub.cfg.dfl
	cp -f ${FETCHEDDIR}/menu.dfl ${FETCHEDDIR}/ramdisk/
elif [ "$FW_CONFIG_KDUMP" = "y" ] ; then
	cp -f ${FETCHEDDIR}/menu.dfl.kdump ${FETCHEDDIR}/ramdisk/menu.dfl
else
	cp -f ${FETCHEDDIR}/menu.dfl ${FETCHEDDIR}/ramdisk/
fi

echo -e "${TCOLOR_BGREEN}Creating upgrader ramdisk image... (size ${TCOLOR_BYELLOW}${DISK_SIZE}${TCOLOR_BGREEN}kB)${TCOLOR_NORMAL}"
rm -f  ${abspath}/${FETCHEDDIR}/rdisk.gz


if [ "$BLD_CONFIG_ENCRYPT_FIRMWARE" = "y" ] ; then
	if ! $GENEXT2FS -b $DISK_SIZE --root $FETCHEDDIR/ramdisk --squash-uids --devtable $FETCHEDDIR/dev_table $FETCHEDDIR/rdiskpkg.ext3 ; then
		echo_error "Failed to create upgrader ramdisk image."
		exit 1
	fi

	rm -f $FETCHEDDIR/passphrase_file $FETCHEDDIR/rdiskpkg.encrypt $FETCHEDDIR/passphrase_file.encrypt

	# Fix passphrase file size 256 bytes
	if ! openssl rand -base64 256 | dd of=$FETCHEDDIR/passphrase_file bs=256 count=1 || \
		[ ! -f $FETCHEDDIR/passphrase_file ]; then
		echo_error "Failed to create upgrader passphrase file."
		exit 1
	fi

	if ! openssl enc -aes-256-cbc \
		-salt -md md5 \
		-in $FETCHEDDIR/rdiskpkg.ext3 \
		-pass file:$FETCHEDDIR/passphrase_file \
		-out $FETCHEDDIR/rdiskpkg.encrypt || \
		[ ! -f $FETCHEDDIR/rdiskpkg.encrypt ] ; then
		echo_error "Failed to create upgrader encrypted rdisk file."
		exit 1
	fi

	if ! openssl rsautl -encrypt -pubin \
		-inkey $ENCRYPT_FW_PUBLIC_KEY \
		-in $FETCHEDDIR/passphrase_file \
		-out $FETCHEDDIR/passphrase_file.encrypt || \
		[ ! -f $FETCHEDDIR/passphrase_file.encrypt ] ; then
		echo_error "Failed to create upgrader encrypted passphrase file."
		exit 1
	fi

	sed -i 's/^Salted__/pEfWim/' $FETCHEDDIR/rdiskpkg.encrypt || exit $?

	# Packing the rdiskpkg
	dd if=$FETCHEDDIR/passphrase_file.encrypt of=$FETCHEDDIR/rdiskpkg
	dd if=$FETCHEDDIR/rdiskpkg.encrypt of=$FETCHEDDIR/rdiskpkg oflag=append conv=notrunc
else
	if ! $GENEXT2FS -b $DISK_SIZE \
		--root $FETCHEDDIR/ramdisk --squash-uids \
		--devtable $FETCHEDDIR/dev_table \
		$FETCHEDDIR/rdiskpkg ; then
		echo_error "Failed to create upgrader ramdisk image."
		exit 1
	fi
fi

echo "Switching to directory> $abspath/$FETCHEDDIR"
cd $abspath/$FETCHEDDIR

firmware_package_and_sign ${KERNEL_IMAGE} ${RDISKIMAGE} || exit $?
