#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

make -C ${FETCHEDDIR} CROSSCOMPILER_PREFIX="$HOST_PREFIX-" tcpserver tcpclient ${MAKE_OPTS} || exit 1
