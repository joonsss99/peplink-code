#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR
make -C brctl DESTDIR=$abspath/$MNT install || exit $?
$HOST_PREFIX-strip $abspath/$MNT/usr/sbin/brctl || exit $?
