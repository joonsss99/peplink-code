#!/bin/sh

PACKAGE=$1

abspath=`pwd`
FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd ${FETCHEDDIR}

make ${MAKE_OPTS} CC=${HOST_PREFIX}-gcc CFLAGS="-I${STAGING}/usr/include" LDFLAGS="-L${STAGING}/usr/lib" || exit $?
