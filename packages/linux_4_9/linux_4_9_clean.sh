#!/bin/sh

PACKAGE=$1

FETCHEDDIR=$KERNEL_SRC

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

case $PL_BUILD_ARCH in
x86*)
	karch=x86
	kimage=$KIMAGE_NAME
	;;
ixp|arm)
	karch=arm
	kimage=$KIMAGE_NAME
	;;
arm64)
	karch=arm64
	kimage=$KIMAGE_NAME
	;;
ar7100)
	karch=mips
	kimage=$KIMAGE_NAME
	;;
powerpc)
	karch=powerpc
	kimage=$KIMAGE_NAME
	;;
*)
	echo "arch not supported $PL_BUILD_ARCH"
	exit 1
	;;
esac

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	makeflag="O=$KERNEL_OBJ"
fi

make -C $FETCHEDDIR $makeflag clean
rm -f $KERNEL_OBJ/arch/$karch/boot/$kimage
