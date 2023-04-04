#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd ${FETCHEDDIR}

if [ ! -f Makefile ]; then
	./configure \
		--host=$HOST_PREFIX \
		--disable-shared || exit $?
fi

make ${MAKE_OPTS} CFLAGS="-fPIC -DPIC" || exit $?

mkdir -p ${STAGING}/usr/include/libgmp/ || exit $?
cp -f ./.libs/libgmp.la ${STAGING}/usr/lib/ || exit $?
cp -f ./.libs/libgmp.a ${STAGING}/usr/lib/ || exit $?
cp -f ./gmp.h ${STAGING}/usr/include/ || exit $?

