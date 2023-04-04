#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

make -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- login.$BUILD_MODEL || exit $?
