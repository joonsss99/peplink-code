#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

cd $FETCHEDDIR || exit $?

if [ ! -x configure ]; then
	./autogen.sh || exit $?
fi

if [ ! -f Makefile ]; then
	./configure --prefix=/usr --host=$HOST_PREFIX || exit $?
fi

make $MAKE_OPTS || exit $?
make $MAKE_OPTS DESTDIR=$STAGING install || exit $?
rm -f $STAGING/usr/lib/libnl*.la
