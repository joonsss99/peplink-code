#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd ${FETCHEDDIR}

if [ ! -f configure ]; then
	./bootstrap --no-bootstrap-sync --skip-po --gnulib-srcdir=./gnulib
fi

if [ ! -f Makefile ]; then
	CFLAGS="-I${STAGING}/usr/include" \
	CPPFLAGS="-I${STAGING}/usr/include" \
	LDFLAGS="-L${STAGING}/usr/lib" \
	./configure --host=${HOST_PREFIX} \
		--disable-device-mapper \
		--without-readline \
		--disable-shared \
		|| exit $?
fi

make || exit $?
