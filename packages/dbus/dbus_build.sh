#!/bin/sh

PACKAGE=$1

abspath=`pwd`
FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd ${FETCHEDDIR}

if [ ! -f configure ]; then
	autoreconf -f -i -Wall,no-obsolete || exit $?
fi

if [ ! -f Makefile ]; then
	CFLAGS="-I${STAGING}/usr/include -I${STAGING}/usr/local/include" \
	CPPFLAGS="-I${STAGING}/usr/include" \
	EXPAT_CFLAGS="-I${STAGING}/usr/local/include" \
	EXPAT_LIBS="-L${STAGING}/usr/lib -lexpat" \
	LDFLAGS="-L${STAGING}/usr/lib -L${STAGING}/usr/local/lib -lglib-2.0 -lgmodule-2.0 -lffi -lz" \
		./configure --prefix=/usr --host=${HOST_PREFIX} --disable-systemd \
		--disable-xml-docs --disable-doxygen-docs --disable-ducktype-docs \
		--disable-selinux \
		|| exit $?
fi

make ${MAKE_OPTS} || exit $?
make ${MAKE_OPTS} DESTDIR=${STAGING} install || exit $?
rm -f ${STAGING}/usr/lib/libdbus*.la
