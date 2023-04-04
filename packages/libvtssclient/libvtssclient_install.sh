#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

FMK="-f ${PROJECT_MAKE}/Makefile"

make ${FMK} ${MAKE_OPTS} -C ${FETCHEDDIR} DESTDIR=${abspath}/${MNT} CROSS_COMPILE=$HOST_PREFIX- install || exit $?
