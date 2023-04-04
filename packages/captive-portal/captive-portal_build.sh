#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/captive-portal

. ./make.conf

abspath=`pwd`

make -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS all || exit $?
