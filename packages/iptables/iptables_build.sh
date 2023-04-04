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
	./configure --prefix=/ \
		--host=$HOST_PREFIX \
		--libexecdir=/usr/lib \
		--includedir=/usr/include \
		--with-xtlibdir=/usr/lib/xtables \
		--with-kernel=$KERNEL_HEADERS \
		--disable-nftables
fi

make $MAKE_OPTS || exit $?
make DESTDIR=$STAGING install || exit $?
make DESTDIR=$abspath/$FETCHEDDIR/staging install || exit $?
