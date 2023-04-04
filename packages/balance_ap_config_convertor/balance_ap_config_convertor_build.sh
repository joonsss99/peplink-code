#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

make -C $FETCHEDDIR $MAKE_OPTS CROSS_COMPILE=$HOST_PREFIX- || exit $?
