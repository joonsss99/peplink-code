#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

# clean
[ -f ${FETCHEDDIR}/Makefile ] && make -C ${FETCHEDDIR} clean
