#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

cd $FETCHEDDIR || exit 1

if [ ! -f Makefile ] ; then

	if [ "${BUILD_TARGET}" = "maxotg" ]; then
		TD_EXTRA_OPTION="--disable-ipv6 --without-smi --disable-universal"
	else
		TD_EXTRA_OPTION=""
	fi

	CFLAGS="-I$STAGING/usr/include" \
	CPPFLAGS="-I$STAGING/usr/include" \
	LDFLAGS="-L$STAGING/usr/lib" \
	LIB="-lpcap" \
	td_cv_buggygetaddrinfo=no \
	./configure --host=$HOST_PREFIX --prefix=/usr \
		--disable-local-libpcap \
		--disable-smb $TD_EXTRA_OPTION \
		--without-smi || exit $?
fi

make $MAKE_OPTS || exit $?
