#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd ${FETCHEDDIR}
if [ ! -f configure ] ; then
	autoreconf -fi || exit $?
fi

if [ ! -f Makefile ]; then
	# force $cross_compiling to yes in configure script by using different --build and --host prefix
	OPENSSL_CFLAGS="-I${STAGING}/usr/include -DPISMO_LOG_USERNAME -DPISMO_KILL_CN_RESTART -DPRECISE_EXIT_CODE -DIGNORE_IPV6_ERROR -DPISMO_REPORT_SERVER_IP" \
	OPENSSL_LIBS="-L${STAGING}/usr/lib -lssl -lcrypto -lpepos_dhcpc -lpepos" \
	IFCONFIG=/sbin/ifconfig \
	ROUTE=/sbin/route \
	IPROUTE=/bin/ip \
	NETSTAT=/bin/netstat \
	./configure --build=`gcc -dumpmachine` --host=$HOST_PREFIX --with-zlib=$STAGING/usr --disable-lzo --enable-plugins --disable-plugin-auth-pam --enable-iproute2 || exit $?
fi

make $MAKE_OPTS
