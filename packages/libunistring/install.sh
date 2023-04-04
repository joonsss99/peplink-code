#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

cd ${FETCHEDDIR} || exit $?

DEST_LIB_DIR="${abspath}/${MNT}/usr/lib"
mkdir -p "${DEST_LIB_DIR}" || exit $?
cp -dpf lib/.libs/libunistring.so* "${DEST_LIB_DIR}/" || exit $?
${HOST_PREFIX}-strip "${DEST_LIB_DIR}/libunistring.so"* || exit $?
