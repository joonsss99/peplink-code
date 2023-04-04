#!/bin/sh

PACKAGE=$1

FETCHEDDIR=$KERNEL_SRC

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	mkdir -p $KERNEL_OBJ
	mkdir -p $PWD/kernel.kdump

	make -C $FETCHEDDIR ARCH=$KERNEL_ARCH $KERNEL_CONFIG_NAME O=$KERNEL_OBJ || exit $?
	make -C $FETCHEDDIR ARCH=$KERNEL_ARCH $KDUMP_CONFIG_NAME O=$PWD/kernel.kdump || exit $?
else
	make -C $FETCHEDDIR ARCH=$KERNEL_ARCH $KERNEL_CONFIG_NAME
fi

