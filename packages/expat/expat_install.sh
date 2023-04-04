#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

DESTDIR=${abspath}/${MNT}/lib

mkdir -p ${DESTDIR} || exit $?
cp -dpf ${FETCHEDDIR}/expat/lib/.libs/libexpat.so* ${DESTDIR}/ || exit $?
$HOST_PREFIX-strip ${DESTDIR}/libexpat.so*
