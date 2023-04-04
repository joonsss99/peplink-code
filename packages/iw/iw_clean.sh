#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

cd $FETCHEDDIR || exit $?

make $MAKE_OPTS CC=${HOST_PREFIX}-gcc \
	NO_PKG_CONFIG=1 clean || exit $?
