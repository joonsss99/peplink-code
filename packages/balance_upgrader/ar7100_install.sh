#!/bin/sh

PACKAGE=$1
DISK_SIZE=16380
ENCRYPT_RDISK_SIZE=${BLD_CONFIG_ENCRYPT_RDISK_SIZE:-21}

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions
. $PACKAGESDIR/common/upgrader_functions

abspath=`pwd`

HOST_TOOLS_DIR=$abspath/tools/host/bin

FIWM_BIN=$HOST_TOOLS_DIR/fiwm
VERISIGN_BIN=$HOST_TOOLS_DIR/peplink_sign_firmware

VMLINUX=${abspath}/images/vmlinux.bin
FW_VERSION=${abspath}/${MNT}/etc/software-release
VERSION=`cat $FW_VERSION`
BUILD_NUMBER=`cat plb.bno`

VMLINUX_LZMA=${abspath}/images/vmlinux.pep
KERNEL_IMAGE=$VMLINUX_LZMA
sudo_cmd=sudo

export MNT_ABSPATH=${abspath}/$MNT

if [ ! -f ${VMLINUX} ]; then
echo "${VMLINUX} not found"
exit 1
fi

if [ ! -f ${FW_VERSION} ]; then
echo "${FW_VERSION} not found"
exit 1
fi

if [ "$BLD_CONFIG_USE_SFS" = "y" ]; then
	RDISKIMAGE=${abspath}/images/rdisk.sfs
	TARGET_IMAGE="rdisk.sfs"
else
	RDISKIMAGE=${abspath}/images/rdisk.gz
	TARGET_IMAGE="rootdisk.tar.gz"
fi

if [ ! -f ${RDISKIMAGE} ]; then
echo "${RDISKIMAGE} not found"
exit 1
fi

if [ "$BLD_CONFIG_ENCRYPT_RDISK" = "y" ]; then
	ENCRYPT_RDISK=${FETCHEDDIR}/encrypt.fs
	CRYPT_DEV_NAME="${PL_BUILD_ARCH}_`date +%s`"

        rm -rf ${FETCHEDDIR}/encrypt.fs

        if ! dd if=/dev/zero bs=1M count=$ENCRYPT_RDISK_SIZE of=${FETCHEDDIR}/encrypt.fs ; then
                echo_error "Failed to create encryption file."
                exit 1
        fi
        if ! $sudo_cmd cryptsetup luksFormat --type luks1 --cipher serpent --batch-mode --pbkdf-force-iterations 16874 ${FETCHEDDIR}/encrypt.fs $ENCRYPT_RDISK_KEY ; then
                echo_error "Failed to luksFormat encryption file."
                exit 1
        fi
        if ! $sudo_cmd cryptsetup luksOpen ${FETCHEDDIR}/encrypt.fs $CRYPT_DEV_NAME -d $ENCRYPT_RDISK_KEY ; then
                echo_error "Failed to luksOpen encryption file."
                exit 1
        fi

	if ! $sudo_cmd dd if=$RDISKIMAGE of=/dev/mapper/${CRYPT_DEV_NAME} ; then
		$sudo_cmd cryptsetup luksClose $CRYPT_DEV_NAME
		echo_error "Failed to write squiashfs file"
		exit 1
	fi

	sync
	$sudo_cmd cryptsetup luksClose $CRYPT_DEV_NAME

        ln -sf ${abspath}/$ENCRYPT_RDISK  ${abspath}/images/encrypt.fs
        if [ ! -f ${ENCRYPT_RDISK} ]; then
                echo "${BZIMAGE} not found"
                exit 1
        fi

	# Update RDISKIMAGE and TARGET_IMAGE
	RDISKIMAGE=encrypt.fs
	TARGET_IMAGE="rdisk"
else
	# Encrypt rdisk.sfs
	for bmseries in $FIRMWARE_MODEL_LIST; do
		if ! cat $abspath/keys/firmware/public.key.$bmseries | grep -v "^\-" > ${FETCHEDDIR}/key ; then
			echo_error "Failed to generate key for $bmseries rdisk.sfs"
		fi
		if ! cat $RDISKIMAGE | openssl aes-256-cbc -md md5 -kfile ${FETCHEDDIR}/key > ${FETCHEDDIR}/r.${bmseries}.$$ ; then
			echo_error "Failed to create encrypted $bmseries rootdisk file"
		fi
		if ! cat ${FETCHEDDIR}/r.${bmseries}.$$ | sed 's/Salted/pE9138/' > ${FETCHEDDIR}/r.$bmseries ; then
			echo_error "Failed to remove Salted from $bmseries encrypted rootdisk file"
		fi
		rm -f ${FETCHEDDIR}/r.${bmseries}.$$
	done
fi

cd ${FETCHEDDIR}

echo "ln -snf ${RDISKIMAGE} ${TARGET_IMAGE} "
ln -snf ${RDISKIMAGE} ${TARGET_IMAGE}
echo "ln -snf ${VMLINUX} vmlinux.bin"
ln -snf ${VMLINUX} vmlinux.bin

#compress kernel
LZMA_CMD=${HOST_TOOLS_DIR}/lzma
entry=`${HOST_PREFIX}-objdump -f ${KERNEL_DIR}/vmlinux | grep "start address 0x" | cut -f3 -d' '`
echo "Kernel entry point: $entry"
entrynox=${entry#0x}
ent=""
for((i=0;i<8;i+=2))
do
        ent=$ent"\x${entrynox:i:2}"
done
printf $ent > entryaddr
echo -e "${TCOLOR_BGREEN}Compressing ${VMLINUX} to ${VMLINUX_LZMA}...${TCOLOR_NORMAL}"
${LZMA_CMD} -z -f -k -v vmlinux.bin || exit $?
[ ! -f vmlinux.bin.lzma ] && exit 1
cat entryaddr vmlinux.bin.lzma > ${VMLINUX_LZMA}
[ $? -ne 0 ] && exit 1
ln -snf ${abspath}/${FETCHEDDIR}/vmlinux.bin.lzma  ${abspath}/images/vmlinux.bin.lzma
ln -snf ${VMLINUX_LZMA} vmlinux.pep

# Encrypt vmlinux.pep
for bmseries in $FIRMWARE_MODEL_LIST; do
	if ! cat $abspath/keys/firmware/public.key.$bmseries | grep -v "^\-" > key ; then
		echo_error "Failed to generate key for $bmseries vmlinux.pep"
	fi
	if ! cat $KERNEL_IMAGE |  openssl aes-256-cbc -md md5 -kfile key > v.${bmseries}.$$ ; then
		echo_error "Failer to create encrypted $bmseries vmlinux.pep file"
	fi
	if ! cat v.${bmseries}.$$ | sed 's/Salted/pE9138/' > v.$bmseries ; then
		echo_error "Failed to remove Salted from $bmseries encrypted vmlinux.pep file"
	fi
	rm -f v.${bmseries}.$$
done

case $BUILD_TARGET in
balance210b|balance310b)
	EXT2OVRHD=1792
	;;
balance30b|balance30w)
	EXT2OVRHD=1792
	;;
m700)
	EXT2OVRHD=1792
	;;
maxotg|maxdcs|maxbr1ac|maxbr1|plsw|aponeac)
	;;
*)
	echo_error "invalid build target $BUILD_TARGET"
	exit 1
	;;
esac

statefile="$abspath/fakeroot_upgrader"
if [ $USE_FAKEROOT -eq 1 ] ; then
	fakeroot_cmd="$FAKEROOT -p $statefile -d"
	echo "fakeroot_cmd=$fakeroot_cmd"
else
	fakeroot_cmd=""
fi

if ! ./mk-checksum.sh $RDISKIMAGE "r" ; then
	echo_error "Failed to create rdisk image checksum file"
	exit 1
fi

if ! ./mk-checksum.sh $KERNEL_IMAGE "v" ; then
	echo_error "Failed to create kernel iamge checksum file"
	exit 1
fi

export PATH="$HOST_TOOL_DIR/bin:$PATH"
export WEB_DIR="$BALANCE_WEB_DIR"
mksfs_param="${abspath}/$MNT"
mkugr_param="${abspath}/$UPGRADER_ROOT_DIR"
case $BUILD_TARGET in
maxotg|maxbr1|maxdcs|maxbr1ac)
	for bmseries in $FIRMWARE_MODEL_LIST; do
		if ! (rm -f $statefile && $fakeroot_cmd ./mksfspkg.sh $mksfs_param $mkugr_param ${bmseries}); then
			echo_error "failed to build upgrader $bmseries rootdisk image"
			exit 1
		fi
	done
	break
	;;
plsw)
	for swseries in $FIRMWARE_MODEL_LIST ; do
		if ! (rm -f $statefile && $fakeroot_cmd ./mksfspkg.sh $mksfs_param $mkugr_param $swseries); then
			echo_error "failed to build upgrader $swseries rootdisk image"
			exit 1
		fi
	done
	break
	;;
*)
	#create upgrader root disk
	for bmseries in $FIRMWARE_MODEL_LIST; do
		echo -e "${TCOLOR_BGREEN}Creating upgrader ramdisk image...${TCOLOR_NORMAL}"
		(rm -f $statefile && $fakeroot_cmd $abspath/$FETCHEDDIR/mk-ar7100-pkg.sh $EXT2OVRHD $TARGET_IMAGE $mksfs_param $mkugr_param $bmseries) || echo_error "Failed to build upgrader disk image"
	done
	break
	;;
esac

firmware_package_and_sign ${KERNEL_IMAGE} ${RDISKIMAGE} || exit $?
