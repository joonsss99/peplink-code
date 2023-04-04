#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

make -C ${FETCHEDDIR} ${MAKE_OPTS} HOST=${HOST_PREFIX} MANPAGES=no DNS=no HWDB=no LIBKMOD=no LIBZ=${STAGING}/usr/lib/libz.a CROSS_COMPILE=$HOST_PREFIX- OPT="-O2 -I${STAGING}/usr/include" PREFIX=${abspath}/${MNT}/usr clean || exit $?
