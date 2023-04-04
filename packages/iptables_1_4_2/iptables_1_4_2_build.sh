#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

. ./make.conf

cd $FETCHEDDIR

if [ ! -f configure ] ; then
	./autogen.sh || exit $?
fi

if [ ! -f Makefile ] ; then
	CFLAGS="-I$STAGING/usr/include" ./configure \
		--prefix=/ \
		--libexecdir=/usr/lib \
		--includedir=/usr/include \
		--with-ksource=$KERNEL_HEADERS \
		--host=$HOST_PREFIX || exit $?
fi

make $MAKE_OPTS || exit $?
make DESTDIR=`pwd`/build install || exit $?
make DESTDIR=$STAGING install || exit $?

dddir=`pwd`/build

rm -rf $dddir/usr/include \
	$dddir/share \
	$dddir/sbin/ip6tables* \
	$dddir/sbin/iptables-multi \
	$dddir/lib/libxtables.la \
	$dddir/lib/pkgconfig \
	$dddir/bin/iptables-xml
