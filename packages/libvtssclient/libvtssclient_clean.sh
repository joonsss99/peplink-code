#!/bin/

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

FMK="-f ${PROJECT_MAKE}/Makefile"

make ${FMK} ${MAKE_OPTS} -C ${FETCHEDDIR} clean
