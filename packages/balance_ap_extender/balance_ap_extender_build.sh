#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ "${BLD_CONFIG_WLC}" = "y" ]; then
	make -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- || exit $?
else
	# Only build libextenderstorage and libwlcstorage if BLD_CONFIG_WLC != y
	make -C $FETCHEDDIR/libextenderstorage CROSS_COMPILE=$HOST_PREFIX- || exit $?
	make -C $FETCHEDDIR/libwlcstorage CROSS_COMPILE=$HOST_PREFIX- || exit $?
fi
make -C $FETCHEDDIR/libextenderstorage CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$STAGING install-dev || exit $?
make -C $FETCHEDDIR/libwlcstorage CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$STAGING install-dev || exit $?
