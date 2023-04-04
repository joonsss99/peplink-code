#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}
SMARTMONTOOLSDIR=${FETCHEDDIR}/smartmontools

. ${PACKAGESDIR}/common/common_functions

if [ -f ${SMARTMONTOOLSDIR}/Makefile ]; then
	make -C ${SMARTMONTOOLSDIR} distclean
fi
rm -f ${SMARTMONTOOLSDIR}/configure
