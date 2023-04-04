#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

mkdir -p $abspath/$MNT/usr/lib/
cp -df ${FETCHEDDIR}/.libs/libpcre*so* $abspath/$MNT/usr/lib/ || exit $?
$HOST_PREFIX-strip $abspath/$MNT/usr/lib/libpcre*so* || exit $?

if [ "$HAS_UPGRADER" = "y" -o "$PL_BUILD_ARCH" = "ar7100" ]; then
	mkdir -p $abspath/${UPGRADER_ROOT_DIR}/usr/lib
	cp -df ${FETCHEDDIR}/.libs/libpcre*so* $abspath/${UPGRADER_ROOT_DIR}/usr/lib/ || exit $?
	$HOST_PREFIX-strip $abspath/${UPGRADER_ROOT_DIR}/usr/lib/libpcre*so* || exit $?
fi
