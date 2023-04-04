#!/bin/sh

set -e

PACKAGE=$1
FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd ${FETCHEDDIR}

if [ ! -f Makefile ]; then
	CFLAGS="-O2" \
	CPPFLAGS="-I${STAGING}/usr/include" \
	LDFLAGS="-L${STAGING}/usr/lib" \
	LIBS="-lcrypto" \
	./configure --host=${HOST_PREFIX} \
		--without-included-popt \
		--disable-md2man \
		--disable-xxhash --disable-zstd --disable-lz4
fi

make ${MAKE_OPTS}
