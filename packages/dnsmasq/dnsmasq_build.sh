#!/bin/sh

PACKAGE=$1

abspath=`pwd`
FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd ${FETCHEDDIR} || exit $?

# [Bug#22503] dnsmasq needs tags from .git to print proper version
git describe || git fetch --tags || exit $?

make ${MAKE_OPTS} CC=${HOST_PREFIX}-gcc CFLAGS="-I${STAGING}/usr/include" LDFLAGS="-L${STAGING}/usr/lib" || exit $?
