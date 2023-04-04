#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

make -C $FETCHEDDIR DESTDIR=${abspath}/${MNT} install || exit $?
