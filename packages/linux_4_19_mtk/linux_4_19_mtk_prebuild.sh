#!/bin/sh

PACKAGE=$1

FETCHEDDIR=$KERNEL_SRC

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

makeflag="-C $FETCHEDDIR ARCH=$KERNEL_ARCH CROSS_COMPILE=$HOST_PREFIX-"

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	mkdir -p $KERNEL_OBJ
	mkdir -p $PWD/kernel.kdump

	make $makeflag $KERNEL_CONFIG_NAME O=$KERNEL_OBJ || exit $?
	make $makeflag $KDUMP_CONFIG_NAME O=$PWD/kernel.kdump || exit $?
else
	make $makeflag $KERNEL_CONFIG_NAME
fi

