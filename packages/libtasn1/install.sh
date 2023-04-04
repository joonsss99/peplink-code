#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

cd ${FETCHEDDIR} || exit $?

DEST_LIB_DIR="${abspath}/${MNT}/usr/lib"
mkdir -p "${DEST_LIB_DIR}" || exit $?
cp -dpf lib/.libs/libtasn1.so* "${DEST_LIB_DIR}/" || exit $?
${HOST_PREFIX}-strip "${DEST_LIB_DIR}/libtasn1.so"* || exit $?
