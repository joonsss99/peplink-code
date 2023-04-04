#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

make -C $FETCHEDDIR CC=${HOST_PREFIX}-gcc \
	NO_PKG_CONFIG=1 \
	LDLIBS="-L$STAGING/usr/lib -lnl-genl-3 -lnl-3 -lm -Os" \
	CFLAGS="-I$STAGING/usr/include/libnl3 -Wall -W -std=gnu99 \
		-fno-strict-aliasing -MD -MP -Os" \
	LIBNL_CFLAGS="y" LIBNL_LDLIBS="y" \
	LIBNL_GENL_CFLAGS="y" LIBNL_GENL_LDLIBS="y" \
	PREFIX=/usr DESTDIR=$abspath/$MNT || exit $?
