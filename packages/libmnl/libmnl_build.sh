#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR || exit $?

if [ ! -e $abspath/$FETCHEDDIR/configure ]; then
	./autogen.sh || exit $?
fi

if [ ! -e $abspath/$FETCHEDDIR/Makefile ]; then
	./configure --prefix=/usr --host=$HOST_PREFIX || exit $?
fi

make $MAKE_OPTS || exit $?
make $MAKE_OPTS DESTDIR=$STAGING install || exit $?
# don't let libtool's generated .la mess with cross-compile
rm -f $STAGING/usr/lib/libmnl.la
