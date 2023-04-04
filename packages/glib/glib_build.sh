#!/bin/sh

PACKAGE=$1

abspath=`pwd`
FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd ${FETCHEDDIR}

if [ ! -f configure ]; then
	NOCONFIGURE=1 ./autogen.sh || exit $?
fi

if [ ! -f Makefile ]; then
	ZLIB_CFLAGS="-I${STAGING}/usr/include" \
	ZLIB_LIBS="-L${STAGING}/usr/lib -lz" \
	LIBFFI_CFLAGS="-I${STAGING}/usr/include" \
	LIBFFI_LIBS="-L${STAGING}/usr/lib -lffi" \
	PCRE_CFLAGS="-I${STAGING}/usr/include" \
	PCRE_LIBS="-L${STAGING}/usr/lib -lpcre" \
	LIBS="-L${STAGING}/usr/lib -lz -lffi" \
	CFLAGS="-I${STAGING}/usr/include" \
	CPPFLAGS="-I${STAGING}/usr/include" \
	LDFLAGS="-L${STAGING}/usr/lib -lffi" \
		./configure --prefix=/usr \
		--host=${HOST_PREFIX} \
		--disable-man \
		--disable-gtk-doc \
		--disable-libmount \
		--disable-libelf \
		--with-pcre=internal \
		|| exit $?
fi

make ${MAKE_OPTS} || exit $?
make ${MAKE_OPTS} DESTDIR=${STAGING} install || exit $?
for i in gio glib gmodule gobject gthread; do
	rm -f ${STAGING}/usr/lib/lib$i*.la
done
