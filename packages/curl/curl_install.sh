#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

(cd ${STAGING} && tar -cf - usr/lib/libcurl.so*) | tar -C ${abspath}/${MNT} -xf -
$HOST_PREFIX-strip ${abspath}/${MNT}/usr/lib/libcurl.so*

mkdir -p ${abspath}/${MNT}/usr/bin/
cp -f ${FETCHEDDIR}/src/.libs/curl ${abspath}/${MNT}/usr/bin/curl || exit $?
${HOST_PREFIX}-strip ${abspath}/${MNT}/usr/bin/curl || exit $?
