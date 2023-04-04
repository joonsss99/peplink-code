#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

cd $FETCHEDDIR || exit $?
if [ ! -f configure ] ; then
	./autogen.sh || exit $?
fi

if [ ! -f Makefile ] ; then
	./configure --host=$HOST_PREFIX --disable-shared --prefix=/usr --with-pic || exit $?
fi

make $MAKE_OPTS || exit $?
make install DESTDIR=$STAGING || exit $?
