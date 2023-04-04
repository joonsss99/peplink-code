#!/bin/sh

PACKAGE=$1

FETCHEDDIR=$KERNEL_SRC

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	makeflag="O=$KERNEL_OBJ"
fi

make -C $FETCHEDDIR $makeflag clean
rm -f $KERNEL_OBJ/arch/$KERNEL_ARCH/boot/$KIMAGE_NAME
