#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

DESTDIR=$abspath/$MNT/usr/bin

mkdir -p ${DESTDIR}
cp -f $abspath/$FETCHEDDIR/iw ${DESTDIR}/ || exit $?
${HOST_PREFIX}-strip ${DESTDIR}/iw || exit $?
