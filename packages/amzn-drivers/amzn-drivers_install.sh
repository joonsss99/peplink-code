#!/bin/sh -x

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

make -C $KERNEL_SRC M=$PWD/$FETCHEDDIR/kernel/linux/ena O=$KERNEL_OBJ INSTALL_MOD_PATH=${abspath}/${MNT} INSTALL_MOD_STRIP=1 modules_install || exit 1
