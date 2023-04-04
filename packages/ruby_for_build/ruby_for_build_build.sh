#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

cd ${FETCHEDDIR}
if [ ! -f "configure" ]; then
	autoconf || exit $?
fi
if [ ! -f "Makefile" ]; then
	BUILD_PREFIX=`gcc -dumpmachine`
	./configure \
		--build=${BUILD_PREFIX} \
		--disable-install-doc \
		--prefix="/usr/local" || exit $?
fi
cd ${abspath}

make -C ${FETCHEDDIR} ${MAKE_OPTS} || exit $?
make -C ${FETCHEDDIR} install DESTDIR=${abspath}/tools/host/ruby || exit $?
