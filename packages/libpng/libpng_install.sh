#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`
DST_DIR="${abspath}/${MNT}/usr/lib"

mkdir -p "${DST_DIR}"
cp -dpf ${FETCHEDDIR}/.libs/libpng16.so* ${DST_DIR}/ || exit $?
${HOST_PREFIX}-strip ${DST_DIR}/libpng16.so* || exit $?
