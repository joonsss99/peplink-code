#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

if [ -f ${FETCHEDDIR}/Makefile ]; then
        make -C ${FETCHEDDIR} distclean
fi

rm -f ${FETCHEDDIR}/configure
