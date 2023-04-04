#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

FMK="-f ${PROJECT_MAKE}/Makefile"

abspath=`pwd`

make ${FMK} ${MAKE_OPTS} -C ${FETCHEDDIR} DESTDIR=${abspath}/${MNT} CROSS_COMPILE=$HOST_PREFIX- install || exit $?

mkdir -p ${abspath}/${MNT}/var/run/switch
