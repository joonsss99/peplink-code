#!/bin/sh

PACKAGE=$1

FETCHEDDIR=$KERNEL_SRC

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

case $PL_BUILD_ARCH in
x86)
	karch=x86
	kimage=$KIMAGE_NAME
	;;
ixp|arm)
	karch=arm
	kimage=$KIMAGE_NAME
	;;
ar7100)
	karch=mips
	kimage=$KIMAGE_NAME
	;;
*)
	echo "arch not supported $PL_BUILD_ARCH"
	exit 1
	;;
esac

make -C $FETCHEDDIR clean
rm -f $FETCHEDDIR/arch/$karch/boot/$kimage

