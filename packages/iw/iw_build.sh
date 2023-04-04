#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

cd $FETCHEDDIR || exit $?

make $MAKE_OPTS CC=${HOST_PREFIX}-gcc \
	NO_PKG_CONFIG=1 \
	LIBS="-L$STAGING/usr/lib -lnl-genl-3 -lnl-3" \
	CFLAGS="-I$STAGING/usr/include/libnl3 -DCONFIG_LIBNL30" \
	PREFIX=/usr DESTDIR=$abspath/$MNT || exit $?
