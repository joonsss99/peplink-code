#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

cd $FETCHEDDIR || exit $?

make $MAKE_OPTS CC=${HOST_PREFIX}-gcc \
	NO_PKG_CONFIG=1 \
	LIBNL_CFLAGS="y" LIBNL_LDLIBS="y" \
	LIBNL_GENL_CFLAGS="y" LIBNL_GENL_LDLIBS="y" \
	clean || exit $?
