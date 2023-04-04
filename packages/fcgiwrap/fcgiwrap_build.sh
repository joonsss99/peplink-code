#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

cd $FETCHEDDIR || exit $?
if [ ! -f configure ] ; then
	autoreconf -ivf || exit $?
fi
if [ ! -f Makefile ] ; then
	CFLAGS="-g -O2 -I$STAGING/usr/include" LDFLAGS=-L$STAGING/usr/lib ./configure --prefix=/usr --host=$HOST_PREFIX || exit $?
fi

make $MAKE_OPTS || exit $?
