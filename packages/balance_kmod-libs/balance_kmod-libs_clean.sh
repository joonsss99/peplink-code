#!/bin/sh

PACKAGE=balance_kmod

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

make -C ${FETCHEDDIR} LINUXHOME=${KERNEL_DIR} ARCH=$KERNEL_ARCH clean

