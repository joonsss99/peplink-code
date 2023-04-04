#!/bin/sh

PACKAGE=$1

abspath=`pwd`

FETCHEDDIR=${abspath}/${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions
. $PACKAGESDIR/common/upgrader_functions

HOST_TOOLS_DIR=$abspath/tools/host/bin

FIWM_BIN=$HOST_TOOLS_DIR/fiwm
VERISIGN_BIN=$HOST_TOOLS_DIR/peplink_sign_firmware

VMLINUX=${abspath}/images/uImage.fit.pep
KERNEL_IMAGE=$KERNEL_OBJ/vmlinux.bin.gz
FW_VERSION=${abspath}/${MNT}/etc/software-release
BOOTLOADER=${FETCHEDDIR}/powerpc/u-boot*.bin
VERSION=`cat $FW_VERSION`
BUILD_NUMBER=`cat plb.bno`

UIMAGE_SRC="${KERNEL_OBJ}/arch/powerpc/boot/uImage.fit.pep.initrd.all"
makeflag="ARCH=$KERNEL_ARCH CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS CONFIG_FSL_MACH_PISMO_INITRD=y"

GENEXT2FS="$HOST_TOOLS_DIR/genext2fs"

INITRD_DIR="${abspath}/${MNT}/"
INITRD_OUT="${KERNEL_OBJ}/arch/powerpc/boot/ramdisk.image"
RDISKIMAGE=${INITRD_OUT}.gz

if [ ! -f ${FW_VERSION} ]; then
	echo "${FW_VERSION} not found"
	exit 1
fi

cp $FW_VERSION ${abspath}/${UPGRADER_ROOT_DIR}/
cp $BOOTLOADER ${abspath}/${UPGRADER_ROOT_DIR}/

cd ${FETCHEDDIR}

SIZE=$(cat $KERNEL_OBJ/.config | grep CONFIG_BLK_DEV_RAM_SIZE | cut -d'=' -f2)
if [ "$SIZE" = "" ]; then
	SIZE=131072
	echo_error "Cannot get ramdisk size from kernel source, using default = ${SIZE}kB"
fi
if [ "${BLD_CONFIG_SECURITY_APPARMOR_UTILS}" = "y" ]; then
	SIZE=$((SIZE + 24576))
fi

# Generate ramdisk.image.gz
rm -f $INITRD_OUT ${INITRD_OUT}.gz
echo "$GENEXT2FS -b $SIZE --root $INITRD_DIR --squash-uids --devtable $FETCHEDDIR/dev_table $INITRD_OUT"
if ! $GENEXT2FS -b $SIZE --root $INITRD_DIR --squash-uids --devtable $FETCHEDDIR/dev_table $INITRD_OUT; then
	echo_error "Failed to create upgrader ramdisk image."
	exit 1
fi
# compress ramdisk
echo -e "${TCOLOR_BGREEN}Compressing ${TCOLOR_BYELLOW}$rdisk${TCOLOR_NORMAL}"
if which pigz > /dev/null 2>&1 ; then
	pigz -f9 $INITRD_OUT
else
	gzip -f9 $INITRD_OUT
fi

# Creating uImage.fit.pep.all
if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	makeflag="$makeflag O=$KERNEL_OBJ"
fi

echo -e "${TCOLOR_BGREEN}Creating uImage.fit.pep.all ...${TCOLOR_NORMAL}"
if [ ! -f $KERNEL_OBJ/.config ]; then
	echo "${KERNEL_OBJ}: .config file is missing"
	exit 1
fi

rm -f ${UIMAGE_SRC}
make -C ${KERNEL_SRC} $makeflag all || exit $?
##

if [ ! -f ${UIMAGE_SRC} ]; then
	echo "${UIMAGE_SRC} not found"
	exit 1
fi

cp -f $UIMAGE_SRC $VMLINUX

if [ ! -f ${VMLINUX} ]; then
	echo "${VMLINUX} not found"
	exit 1
fi

echo "ln -snf ${VMLINUX} uImage.fit.pep"
ln -snf ${VMLINUX} uImage.fit.pep

case $BUILD_TARGET in
maxhd4|maxdcs_ppc)
	EXT2OVRHD=1792
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

export WEB_DIR="$BALANCE_WEB_DIR"

case $BUILD_TARGET in
maxhd4|maxdcs_ppc)
	if ! (rm -f $statefile && $fakeroot_cmd ./mk-powerpc-pkg.sh $EXT2OVRHD); then
		echo_error "failed to build upgrader rootdisk image"
		exit 1
	fi
	;;
*)
	echo_error "Failed to build upgrader disk image"
	;;
esac

firmware_package_and_sign ${UIMAGE_SRC} ${RDISKIMAGE} || exit $?
