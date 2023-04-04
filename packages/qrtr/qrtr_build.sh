#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

make -C $FETCHEDDIR CFLAGS="-I $STAGING/usr/include/" CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS || exit $?
