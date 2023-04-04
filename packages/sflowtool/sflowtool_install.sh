#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

make -C ${FETCHEDDIR} DESTDIR=${abspath}/${MNT} install-strip || exit $?
mkdir -p ${abspath}/${MNT}/var/run/sflow
