#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

if [ -f ${FETCHEDDIR}/Makefile ]; then
	make -C ${FETCHEDDIR} distclean
fi
rm -f ${FETCHEDDIR}/Makefile
rm -f ${FETCHEDDIR}/configure
