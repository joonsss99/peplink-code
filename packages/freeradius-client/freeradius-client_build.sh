#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

CUSTOM_CFLAGS="-DPISMO_ACCT_RETRY_CONFIG -DPISMO_AUTH_PASS_LEN -DPISMO_AUTH_MSCHAPV2 -DPISMO_RADIUS_STATISTICS -I${STAGING}/usr/include"

cd $FETCHEDDIR || exit $?
if [ ! -f configure ] ; then
	autoreconf -fi || exit $?
fi
if [ ! -f Makefile ] ; then
	CFLAGS=$CUSTOM_CFLAGS LDFLAGS="-L${STAGING}/usr/lib" LIBS="-lcrypto -lpepos_radiuslog -lpepos" ./configure \
		--prefix=/usr --host=$HOST_PREFIX || exit $?
fi

make $MAKE_OPTS || exit $?
make DESTDIR=$STAGING install || exit $?
