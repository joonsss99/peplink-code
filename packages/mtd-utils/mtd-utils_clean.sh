#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ -f ${FETCHEDDIR}/Makefile ]; then
	make -C ${FETCHEDDIR} distclean || exit $?
fi
