#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd $FETCHEDDIR || exit $?
if [ ! -f configure ] ; then
	autoreconf -ivf || exit $?
fi
if [ ! -f Makefile ] ; then
	./configure --build=`gcc -dumpmachine` --prefix=/usr --host=$HOST_PREFIX --disable-shared || exit $?
fi

make $MAKE_OPTS || exit $?
make install DESTDIR=$STAGING || exit $?
