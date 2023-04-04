#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

if [ -f ${FETCHEDDIR}/unix/Makefile ]; then
	make -C "${FETCHEDDIR}/unix" distclean
fi
