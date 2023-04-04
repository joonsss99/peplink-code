#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

make -f $PROJECT_MAKE/Makefile -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$abspath/$MNT install || exit $?
mkdir -p $abspath/$MNT/var/run/ilink/sqlite/
cp -f $FETCHEDDIR/route.schema  $abspath/$MNT/var/run/ilink/sqlite/ || exit $?
