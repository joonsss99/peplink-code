#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

INCDIR=${STAGING}/usr/include/libcgi/
DESTDIR=$abspath/$MNT/usr/lib/

mkdir -p ${DESTDIR}
make -C ${FETCHEDDIR} LIBDIR=${DESTDIR} INCDIR=${INCDIR} install || exit $?
$HOST_PREFIX-strip ${DESTDIR}/libcgi*so*
