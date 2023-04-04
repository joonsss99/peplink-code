#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR || exit 1

if [ ! -f Makefile ] ; then
	CFLAGS="-I$STAGING/usr/include" LDFLAGS="-L$STAGING/usr/lib" LIBS="" ./configure --host=$HOST_PREFIX --prefix=/usr || exit $?
fi

echo $MAKE_OPTS
make $MAKE_OPTS || exit $?

