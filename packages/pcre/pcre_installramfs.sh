#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

DESTDIR=${abspath}/${RAMFS_ROOT}/usr/lib

mkdir -p ${DESTDIR}
cp -df ${FETCHEDDIR}/.libs/libpcre*so* ${DESTDIR}/ || exit $?
${HOST_PREFIX}-strip ${DESTDIR}/libpcre*so* || exit $?
