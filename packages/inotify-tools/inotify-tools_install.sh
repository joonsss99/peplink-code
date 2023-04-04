#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

install -D -p --strip --strip-program=${HOST_PREFIX}-strip \
	${FETCHEDDIR}/src/.libs/inotifywait \
	"${abspath}/${MNT}/usr/bin/inotifywait" || exit $?

DST_DIR="${abspath}/${MNT}/usr/lib"
mkdir -p "${DST_DIR}" || exit $?
cp -dpf ${FETCHEDDIR}/libinotifytools/src/.libs/libinotifytools.so* ${DST_DIR}/
${HOST_PREFIX}-strip ${DST_DIR}/libinotifytools.so*
