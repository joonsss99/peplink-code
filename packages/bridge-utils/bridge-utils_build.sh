#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

cd $FETCHEDDIR || exit $?
if [ ! -f configure ] ; then
	autoreconf -fi || exit $?
fi

if [ ! -f Makefile ] ; then
	./configure --prefix=/usr --host=$HOST_PREFIX --with-linux-headers=$STAGING/usr/include || exit $?
fi

make $MAKE_OPTS || exit $?
