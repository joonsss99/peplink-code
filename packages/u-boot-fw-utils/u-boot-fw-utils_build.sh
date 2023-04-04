#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

cd ${FETCHEDDIR}
make CROSS_COMPILE=$HOST_PREFIX- HOSTCC=$HOST_PREFIX-gcc HOSTSTRIP=$HOST_PREFIX-strip env || exit $?
