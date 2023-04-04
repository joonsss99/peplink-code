#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

CC=$HOST_PREFIX-gcc
CXX=$HOST_PREFIX-g++
STRIP=$HOST_PREFIX-strip

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

make -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- || exit $?

