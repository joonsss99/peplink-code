#!/bin/sh

PACKAGE=$1

abspath=`pwd`

FETCHEDDIR=${abspath}/${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions
. $PACKAGESDIR/common/upgrader_functions

HOST_TOOLS_DIR=$abspath/tools/host/bin
FIWM_BIN=$HOST_TOOLS_DIR/fiwm
VERISIGN_BIN=$HOST_TOOLS_DIR/peplink_sign_firmware

GENEXT2FS="$HOST_TOOLS_DIR/genext2fs"
VMLINUX=${abspath}/images/uImage.fit.pep
FW_VERSION=${abspath}/${MNT}/etc/software-release
VERSION=`cat $FW_VERSION`
UIMAGE_SRC="${KERNEL_OBJ}/arch/$KERNEL_ARCH/boot/uImage.fit.pep.all"
makeflag="ARCH=$KERNEL_ARCH CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS"
BUILD_NUMBER=`cat plb.bno`

export PATH="$HOST_TOOL_DIR/bin:$PATH"

if [ ! -f ${FW_VERSION} ]; then
	echo "${FW_VERSION} not found"
	exit 1
fi

cp -f $FW_VERSION ${abspath}/${UPGRADER_ROOT_DIR}/

cd ${FETCHEDDIR}

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
if [ ! -f ${UIMAGE_SRC} ]; then
	echo "${UIMAGE_SRC} not found"
	exit 1
fi

cp -f $UIMAGE_SRC $VMLINUX
if [ ! -f ${VMLINUX} ]; then
	echo "${VMLINUX} not found"
	exit 1
fi

#echo "ln -snf ${VMLINUX} uImage.fit.pep"
ln -snf ${VMLINUX} uImage.fit.pep

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

ln -snf ${RDISKIMAGE} ${TARGET_IMAGE}

case $BUILD_TARGET in
ramips|maxdcs_ramips|aponeac)
	EXT2OVRHD=1792
	;;
*)
	echo_error "invalid build target $BUILD_TARGET"
	exit 1
	;;
esac

if [ $USE_FAKEROOT -eq 1 ] ; then
	#echo "fakeroot_cmd=$fakeroot_cmd"
	fakeroot_cmd="$FAKEROOT -p $abspath/fakeroot_upgrader -d"
else
	fakeroot_cmd=""
fi

export WEB_DIR="$BALANCE_WEB_DIR"

if [ "$BLD_CONFIG_ENCRYPT_FIRMWARE" = "y" ] ; then
	PARAM_ENCRYPT_FW="1"
	PARAM_ENCRYPT_KEY="${abspath}/${ENCRYPT_FW_PUBLIC_KEY}"
fi

case $BUILD_TARGET in
ramips|maxdcs_ramips|aponeac)
	if ! $fakeroot_cmd ./mk-arm-pkg.sh $EXT2OVRHD $PARAM_ENCRYPT_FW $PARAM_ENCRYPT_KEY "${RDISKIMAGE} ${UIMAGE_SRC}"; then
		echo_error "failed to build upgrader rootdisk image"
		exit 1
	fi
	;;
*)
	echo_error "Failed to build upgrader disk image"
	;;
esac

firmware_package_and_sign ${UIMAGE_SRC} ${RDISKIMAGE} || exit $?
