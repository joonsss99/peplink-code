#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

cd ${FETCHEDDIR}

if [ ! -f configure ] ; then
        autoreconf -fi || exit $?
fi

if [ ! -f Makefile ]; then
        CFLAGS="-I$STAGING/usr/include" \
        LDFLAGS="-L$STAGING/usr/lib" \
	LIBS="-L$STAGING/lib -L$STAGING/usr/lib" \
        ./configure --host=$HOST_PREFIX || exit $?
fi

make $MAKE_OPTS || exit $?

cp -a ./libtac/include/tacplus.h ${STAGING}/usr/include/
cp -a ./libtac/include/libtac.h ${STAGING}/usr/include/
cp -a ./.libs/libtac.so* ${STAGING}/usr/lib/
