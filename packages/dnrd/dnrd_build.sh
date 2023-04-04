#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR || exit $?

if [ ! -f configure ] ; then
	autoreconf -i || exit $?
fi

if [ ! -f Makefile ] ; then
	./configure --build=`gcc -dumpmachine` --host=$HOST_PREFIX --prefix=/ --disable-random-src || exit $?
fi

make $MAKE_OPTS || exit $?
