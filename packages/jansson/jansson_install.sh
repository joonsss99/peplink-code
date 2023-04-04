#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

make -C $FETCHEDDIR DESTDIR=$abspath/$MNT install-exec || exit $?

rm $abspath/$MNT/usr/lib/libjansson.la $abspath/$MNT/usr/lib/libjansson.a
$HOST_PREFIX-strip $abspath/$MNT/usr/lib/libjansson.so*
