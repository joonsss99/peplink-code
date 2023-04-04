#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

DST_DIR=${abspath}/${MNT}/usr/lib

mkdir -p ${DST_DIR}/sasl2 || exit $?
cp -dpf ${FETCHEDDIR}/lib/.libs/libsasl2.so* ${DST_DIR}/ || exit $?
cp -dpf ${FETCHEDDIR}/plugins/.libs/lib*.so* ${DST_DIR}/sasl2/ || exit $?
${HOST_PREFIX}-strip ${DST_DIR}/libsasl2.so* \
	${DST_DIR}/sasl2/lib*.so* || exit $?
