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
	./configure --host=$HOST_PREFIX --prefix=/usr || exit $?
fi

make $MAKE_OPTS || exit $?
make install DESTDIR=$STAGING || exit $?
