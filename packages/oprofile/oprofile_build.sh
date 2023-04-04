#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR
if [ ! -f Makefile ] ; then
	CXXFLAGS="-I$STAGING/usr/include" CFLAGS="-I$STAGING/usr/include" LDFLAGS="-L$STAGING/usr/lib" \
		./configure --build=`gcc -dumpmachine` --host=$HOST_PREFIX --prefix=/usr \
		--with-kernel-support --with-kernel=$KERNEL_HEADERS || exit $?
fi

make $MAKE_OPTS || exit $?
make install DESTDIR=$STAGING || exit $?

