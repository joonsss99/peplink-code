#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

DST_DIR="${abspath}/${MNT}/usr/lib/"
mkdir -p "${DST_DIR}" || exit $?
cp -dpf ${FETCHEDDIR}/${HOST_PREFIX}/.libs/libffi.so* ${DST_DIR}/ || exit $?
${HOST_PREFIX}-strip ${DST_DIR}/libffi.so* || exit $?
