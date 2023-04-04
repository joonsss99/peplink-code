#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

if [ "${BLD_CONFIG_MEDIAFAST_WEBPROXY}" = "y" ]; then
HOST_PREFIX=${HOST_PREFIX} make -C ${FETCHEDDIR} ${MAKE_OPTS} || exit $?
fi
