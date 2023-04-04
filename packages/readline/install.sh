#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

make -C ${FETCHEDDIR}/shlib DESTDIR="${abspath}/${MNT}" install-supported || exit $?
