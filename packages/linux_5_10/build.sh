#!/bin/sh

PACKAGE=$1

FETCHEDDIR=$KERNEL_SRC

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

makeflag="ARCH=$KERNEL_ARCH CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS"

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	makeflag="$makeflag O=$KERNEL_OBJ"
fi

echo -e "${TCOLOR_BGREEN}building linux kernel...${TCOLOR_NORMAL}"
if [ ! -f $KERNEL_OBJ/.config ]; then
	echo "${PACKAGE}: .config file is missing"
	exit 1
fi
make -C ${FETCHEDDIR} $makeflag oldconfig || exit $?
make -C ${FETCHEDDIR} $makeflag all || exit $?
make -C $FETCHEDDIR $makeflag headers_install INSTALL_HDR_PATH=$STAGING/khdrs || exit $?

kheaders_rsync $STAGING/khdrs/ $STAGING/khdrs-1/ $KERNEL_HEADERS

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	echo -e "${TCOLOR_BGREEN}building kdump kernel...${TCOLOR_NORMAL}"
	make -C $FETCHEDDIR ARCH=$KERNEL_ARCH CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS O=$PWD/kernel.kdump all || exit $?
fi
