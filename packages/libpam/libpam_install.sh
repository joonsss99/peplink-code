#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd ${FETCHEDDIR}

mkdir -p ${abspath}/${MNT}/usr/lib/
cp -a ./libpam/.libs/libpam.so* ${abspath}/${MNT}/usr/lib/ || exit $?
$HOST_PREFIX-strip $abspath/$MNT/usr/lib/libpam.so* || exit $?
