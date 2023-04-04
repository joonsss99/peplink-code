#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

#conf_args='--disable-nls'

#cd $FETCHEDDIR
#if [ ! -e $FETCHEDDIR/Makefile ] ; then
#	./configure --host=$HOST_PREFIX --prefix=/usr $conf_args || exit $?
#fi

VPN_DIR="speedfusion"

cd $FETCHEDDIR || exit $?

if [ ! -f configure ]; then
	# EDDY: run automake to config.sub update and also ignore the return value
	automake -acf
	autoreconf -vif || exit $?
fi

if [ ! -f Makefile ]; then
	LDFLAGS="-L${STAGING}/usr/lib -Wl,-rpath-link=$STAGING/usr/lib" \
	CPPFLAGS="-I$abspath/${FETCHDIR}/${VPN_DIR}/kernel/vpn_dev -I$STAGING/usr/include" \
		./configure --host=$HOST_PREFIX --disable-client --enable-routedb --enable-fewerlogmsg --enable-bgpbindiface || exit $?
fi

make $MAKE_OPTS || exit $?
