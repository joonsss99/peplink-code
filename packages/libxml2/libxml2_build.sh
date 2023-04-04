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
	LDFLAGS="-L${STAGING}/usr/lib -Wl,-rpath-link=$STAGING/usr/lib" \
		./configure --prefix=/usr --host=${HOST_PREFIX} --without-lzma --without-python \
		--with-zlib=${STAGING}/usr \
		|| exit $?
fi

make ${MAKE_OPTS} || exit $?
make ${MAKE_OPTS} DESTDIR=${STAGING} install || exit $?
rm -f ${STAGING}/usr/lib/libxml2.la
