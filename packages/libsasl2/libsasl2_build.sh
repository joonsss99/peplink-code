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
	CFLAGS="-I${STAGING}/usr/include" \
	LDFLAGS="-L${STAGING}/usr/lib" \
	LIBS="-L${STAGING}/usr/lib -lcrypto -lsqlite3" \
	./configure \
		--host=$HOST_PREFIX \
		--prefix=/usr \
		--sysconfdir=/etc \
		--with-configdir=/etc/sasl2 \
		--with-openssl="${STAGING}/usr" \
		--disable-sample \
		--with-pam=no \
		--enable-digest \
		--disable-cram \
		--disable-scram \
		--disable-otp \
		--disable-anon \
		--disable-plain \
		--disable-gssapi \
		--enable-shared \
		--enable-sql \
		--with-dbpath="/etc/libvirt/passwd.db" \
		--with-dblib=none \
		--with-sqlite3="${STAGING}/usr" \
		--with-mysql=no \
		--with-pgsql=no \
		|| exit $?
fi

make $MAKE_OPTS || exit $?

# install headers and libraries
make install DESTDIR=${STAGING} || exit $?
rm -f ${STAGING}/usr/lib/libsasl2.la
