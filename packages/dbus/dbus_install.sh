#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

DST_DIR=${abspath}/${MNT}/usr/lib

mkdir -p ${DST_DIR} || exit $?
cp -dpf ${FETCHEDDIR}/dbus/.libs/libdbus-1.so* ${DST_DIR}
${HOST_PREFIX}-strip ${DST_DIR}/libdbus-1.so*
