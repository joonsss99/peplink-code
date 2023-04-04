#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd ${FETCHEDDIR}

if [ ! -f configure ]; then
	./bootstrap --no-bootstrap-sync --skip-po --gnulib-srcdir=./gnulib
fi

if [ ! -f Makefile ]; then
	OPTS=
	[ "${BLD_CONFIG_MEDIAFAST_BUILT_IN}" = "y" ] \
		|| OPTS="$OPTS --disable-pcre"
	CFLAGS="-I${STAGING}/usr/include -DMFA_PREFETCH -DCONTENT_HUB" \
	CPPFLAGS="-I${STAGING}/usr/include -DMFA_PREFETCH -DCONTENT_HUB" \
	LDFLAGS="-L${STAGING}/usr/lib -lmfa -lsqlite3 -lstrutils" \
	ZLIB_FLAGS=" " \
	ZLIB_LIBS="-lz" \
	./configure --host=${HOST_PREFIX} \
		--with-libssl-prefix=$STAGING/usr \
		--with-ssl=openssl \
		--disable-opie \
		--disable-nls \
		--disable-ntlm \
		--disable-debug \
		--disable-ipv6 \
		--with-openssl \
		${OPTS} \
		|| exit $?
fi

make || exit $?
