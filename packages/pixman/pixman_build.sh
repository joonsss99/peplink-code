#!/bin/sh

PACKAGE=$1

abspath=`pwd`
FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd ${FETCHEDDIR}

if [ ! -f configure ]; then
	autoreconf -f -i -Wall,no-obsolete || exit $?
fi

if [ ! -f Makefile ]; then
	CFLAGS="-I${STAGING}/usr/include" \
	CPPFLAGS="-I${STAGING}/usr/include" \
	PNG_CFLAGS="-I${STAGING}/usr/include" \
	PNG_LIBS="-L${STAGING}/usr/lib -lpng16 -lz" \
	LDFLAGS="-L${STAGING}/usr/lib" \
		./configure --prefix=/usr --host=${HOST_PREFIX} \
		|| exit $?
fi

make ${MAKE_OPTS}  || exit $?
make ${MAKE_OPTS} DESTDIR=${STAGING} install || exit $?
