#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

make_flags="HAS_GDNS_LB=1"

make -C $FETCHEDDIR $make_flags CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS || exit $?
