#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

cd ${FETCHEDDIR}/libnet

if [ ! -f configure ]; then
	./autogen.sh || exit $?
fi

if [ ! -f Makefile ]; then
	CFLAGS="-I$STAGING/usr/include" \
	libnet_cv_have_packet_socket=yes ./configure \
		--host=$HOST_PREFIX \
		--prefix=/usr \
		--disable-manpages \
		|| exit $?
fi

make $MAKE_OPTS || exit 1

# install headers and libraries
make install DESTDIR=${abspath}/staging || exit 1
