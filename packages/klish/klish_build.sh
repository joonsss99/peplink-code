#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd $FETCHEDDIR || exit $?

if [ ! -f configure ] ; then 
	autoreconf -fvi || exit $?
fi

if [ ! -f Makefile ] ; then
	./configure --host=$HOST_PREFIX --prefix=/usr --disable-shared --disable-gpl || exit $?
fi

make $MAKE_OPTS || exit $?
#make install DESTDIR=$STAGING || exit $?
