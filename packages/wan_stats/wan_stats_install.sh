#!/bin/sh

PACKAGE=$1

. ${PACKAGESDIR}/common/common_functions

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`
MNT_PATH=$abspath/$MNT

common_flags="CROSS_COMPILE=$HOST_PREFIX- MNT_PATH=$MNT_PATH"

make -C $FETCHEDDIR $common_flags DESTDIR=$MNT_PATH install || exit $?
