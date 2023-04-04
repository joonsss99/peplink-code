#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

cd $FETCHEDDIR/src || exit $?

if [ ! -f configure ]; then
	autoheader || exit $?
	autoconf || exit $?
fi

if [ ! -f Makefile ] ; then
	CFLAGS="-Os -I$STAGING/usr/include" LDFLAGS="-L$STAGING/usr/lib" LIBS="-lz" ./configure \
		--prefix=$abspath/$MNT/usr/local/ilink \
		--libdir=$abspath/$MNT/usr/lib \
		--sysconfdir=$abspath/$MNT/etc \
		--without-system-verto \
		--enable-dns-for-realm \
		--host=$HOST_PREFIX || exit $?
fi

make $MAKE_OPTS || exit $?

cp -fL lib/lib*.so ${STAGING}/usr/lib || exit $?
cp -rf include/gssapi include/krb5 include/gssapi.h include/krb5.h \
	include/com_err.h \
	${STAGING}/usr/include || exit $?
