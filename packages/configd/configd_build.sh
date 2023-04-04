#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

FMK="-f ${PROJECT_MAKE}/Makefile"

make ${FMK} ${MAKE_OPTS} -C ${FETCHEDDIR} ${TARGET_SERIES}_defconfig || exit $?
make ${FMK} ${MAKE_OPTS} -C ${FETCHEDDIR} CROSS_COMPILE=$HOST_PREFIX- || exit $?
