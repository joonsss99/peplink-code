#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd ${FETCHEDDIR}

if [ ! -f Makefile ]; then
	CFLAGS="-I$STAGING/usr/include" \
	./configure \
		--host=$HOST_PREFIX \
		--prefix=/usr \
		--disable-manpages \
		--disable-lynx \
		--disable-xmltoman \
		|| exit $?
fi

make $MAKE_OPTS || exit 1
