#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ -f ${FETCHEDDIR}/Makefile.peplink ]; then
	make -C ${FETCHEDDIR} -f Makefile.peplink CROSS_COMPILE=${HOST_PREFIX}-gcc
fi
