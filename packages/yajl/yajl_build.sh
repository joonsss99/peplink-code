#!/bin/sh

PACKAGE=$1

abspath=`pwd`
FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd ${FETCHEDDIR}

if [ ! -f Makefile ]; then
	CFLAGS="-I${STAGING}/usr/include" \
	CPPFLAGS="-I${STAGING}/usr/include" \
	LDFLAGS="-L${STAGING}/usr/lib" \
		./configure --prefix=/usr --host=${HOST_PREFIX} \
		|| exit $?
fi

make ${MAKE_OPTS} distro || exit $?

cp -af build/yajl-*/include/yajl ${STAGING}/usr/include/ || exit $?
cp -af build/yajl-*/lib/lib* ${STAGING}/usr/lib/ || exit $?
