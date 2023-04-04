#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR

if [ ! -f configure ]; then
	./autogen.sh || exit $?
fi

if [ ! -f Makefile ]; then
	CFLAGS="-I${STAGING}/usr/include" LDFLAGS="-L${STAGING}/usr/lib" \
		./configure --host=$HOST_PREFIX --prefix=/usr \
		--disable-debug-mode || exit $?
fi

make $MAKE_OPTS || exit $?
make install DESTDIR=$STAGING || exit $?
