#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

makeflag="ARCH=$KERNEL_ARCH CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS KLIB_BUILD=$KERNEL_OBJ"

make -C ${FETCHEDDIR} $makeflag KLIB=${abspath}/${MNT} INSTALL_MOD_STRIP=1 modules_install
