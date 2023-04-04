#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd ${FETCHEDDIR}

if [ ! -f configure ]; then
	# Bug#14666 Fixed SegFault when calling date/timezone functions using
	#           PHP 5.6.11 on PowerPC
	# Bug#19795 The same for MIPS...
	for FILE in ext/date/lib/parse_tz.c ext/hash/hash_tiger.c Zend/zend_strtod.c; do
		sed -i -e '/^\(#if (defined(__APPLE__) || defined(__APPLE_CC__)\)\() && .*__BIG_ENDIAN__.*__LITTLE_ENDIAN__.*\)/ {
				s,,\1 || defined(__powerpc__)\2,
				:find_endif
				/^#endif/ ! {
					n; b find_endif
				}' \
				-e 'i #else' \
				-e 'i # if defined(__BYTE_ORDER__) && defined(__ORDER_BIG_ENDIAN__) && defined(__ORDER_LITTLE_ENDIAN__)' \
				-e 'i #  if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__' \
				-e 'i #   undef WORDS_BIGENDIAN' \
				-e 'i #  else' \
				-e 'i #   if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__' \
				-e 'i #    define WORDS_BIGENDIAN' \
				-e 'i #   endif' \
				-e 'i #  endif' \
				-e 'i # endif' \
			-e '}' "${FILE}"
	done
	# Patch the configure script which does not (but should) accept Bison
	#   version 3.0.1+ on the build machine
	# See also http://php.net/manual/en/install.unix.php
	sed -i -e '/^\( *bison_version_exclude=\).*/ s||\1"3.0.0"|' \
		-e '/^\( *bison_version=\)"${1}.${2}"/ s||\1${1}.${2}.${3}|' \
		"Zend/acinclude.m4"
	./buildconf --force || exit $?
fi
if [ ! -f Makefile ]; then
	# enable curl + openssl for curl_exec() with HTTPS support
	CURL_CFLAGS="-I${STAGING}/usr/include" \
	CURL_LIBS="-L${STAGING}/usr/lib -lcurl -lssl -lcrypto -lz" \
	OPENSSL_CFLAGS="-I${STAGING}/usr/include" \
	OPENSSL_LIBS="-L${STAGING}/usr/lib -lssl -lcrypto -lz" \
	CC=${CC} ./configure --host=${HOST_PREFIX} \
		--with-curl --with-openssl \
		--without-pear --disable-simplexml --disable-mbregex \
		--enable-sockets --disable-pdo --without-pdo-sqlite \
		--without-sqlite3 --enable-fastcgi --enable-session \
		--enable-json --disable-all --without-valgrind || exit $?
fi
make ${MAKE_OPTS} || exit $?
