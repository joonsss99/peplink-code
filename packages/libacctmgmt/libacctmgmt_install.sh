#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

fmk="-f $PROJECT_MAKE/Makefile"
make $fmk -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$abspath/$MNT install || exit $?
$HOST_PREFIX-strip $abspath/$MNT/usr/lib/libacctmgmt*so*
