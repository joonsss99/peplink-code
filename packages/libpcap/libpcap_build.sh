#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

cd $FETCHEDDIR || exit $?

if [ ! -f Makefile ] ; then
	# EDDY: run automake to config.sub update and also ignore the return value
	automake -acf
	CFLAGS="-I$STAGING/usr/include" \
	ac_cv_linux_vers=2 ./configure --prefix=/usr --host=$HOST_PREFIX \
		--with-pcap=linux \
		--without-libnl \
		--disable-usb \
		--disable-netmap \
		--disable-bluetooth \
		--disable-dbus \
		--disable-rdma \
		|| exit $?
fi

make $MAKE_OPTS || exit $?
make install DESTDIR=$STAGING || exit $?
