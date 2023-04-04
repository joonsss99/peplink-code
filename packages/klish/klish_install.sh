#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

mkdir -p $abspath/$MNT/usr/bin
cp -p $FETCHEDDIR/bin/clish $abspath/$MNT/usr/bin  || exit $?
$HOST_PREFIX-strip $abspath/$MNT/usr/bin/clish || exit $?
