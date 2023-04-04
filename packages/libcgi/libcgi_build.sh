#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

INCDIR=${STAGING}/usr/include/libcgi/
DESTDIR=${STAGING}/usr/lib

make -C ${FETCHEDDIR} LIBSQLITE_PATH=${STAGING}/usr/include || exit $?
make -C ${FETCHEDDIR} LIBDIR=${DESTDIR} INCDIR=${INCDIR} install-dev || exit $?
