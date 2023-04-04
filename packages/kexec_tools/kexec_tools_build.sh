#!/bin/sh

PACKAGE=$1

FETCHEDDIR=$FETCHDIR/$PACKAGE

. ./make.conf

abspath=`pwd`

if [ "$FW_CONFIG_KDUMP" != "y" ]; then
	echo "kdump not enabled, not building."
	exit 0
fi

if [ "${PL_BUILD_ARCH}" = "powerpc" ]; then
	PPCARG="--with-booke"
else
	PPCARG=""
fi

cd $FETCHEDDIR || exit $?

if [ ! -x configure ]; then
	./bootstrap || exit $?
fi

if [ ! -f Makefile ]; then
	CFLAGS="-O2 -I${STAGING}/usr/include" \
	CPPFLAGS="-I${STAGING}/usr/include" \
	LDFLAGS="-L${STAGING}/usr/lib" \
	./configure --prefix=/usr \
		--host=$HOST_PREFIX $PPCARG || exit $?
fi

make $MAKE_OPTS || exit $?
