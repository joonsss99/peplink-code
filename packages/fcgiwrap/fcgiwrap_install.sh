#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

make -C $FETCHEDDIR install DESTDIR=$abspath/$MNT || exit $?
$HOST_PREFIX-strip $abspath/$MNT/usr/sbin/fcgiwrap
