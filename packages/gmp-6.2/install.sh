#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

cd ${FETCHEDDIR} || exit $?

mkdir -p "${abspath}/${MNT}/usr/lib" || exit $?
cp -dpf .libs/libgmp.so* "${abspath}/${MNT}/usr/lib/" || exit $?
${HOST_PREFIX}-strip "${abspath}/${MNT}/usr/lib/libgmp.so"* || exit $?
