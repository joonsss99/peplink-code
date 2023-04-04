#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR || exit $?
if [ ! -e Makefile ] ; then
	# replacing existing configure, also update config.guess and config.sub
	# to modern version and align with build system
	autoreconf -ivf || exit $?
	./configure --with-openssl-libdir=$STAGING/usr/lib \
		    --with-openssl-incdir=$STAGING/usr/include \
		    --with-crypto=openssl \
		    --build=`gcc -dumpmachine` \
		    --host=$HOST_PREFIX \
		    || exit $?
fi

# WARNING: this package is totally unfriendly with parallel build (because of multi-level configure and all sorts of configure dependencies)
#if [ "${PL_BUILD_ARCH}" = "x86" ]; then
#	make -C sntp/libopts || exit $?
#	make -C ntpd || exit $?
#	$HOST_PREFIX-strip ntpd/ntpd || exit $?
	#make -C ntpq || exit $?
#else 
	make -C ntpdate || exit $?
#	$HOST_PREFIX-strip ntpdate/ntpdate || exit $?
#fi
