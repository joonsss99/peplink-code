#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR || exit $?

if [ ! -e configure ]; then
	./bootstrap --skip-po --gnulib-srcdir=./gnulib || exit $?
fi

if [ ! -e Makefile ] || [ configure -nt Makefile ] ; then
	./configure CFLAGS="-O2 -I$STAGING/usr/include" LDFLAGS=-L$STAGING/usr/lib --host=$HOST_PREFIX --disable-nls --enable-gcc-warnings=no || exit $?
fi

make $MAKE_OPTS || exit $?
