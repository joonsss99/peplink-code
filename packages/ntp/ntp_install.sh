#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cp $FETCHEDDIR/ntpdate/ntpdate $abspath/$MNT/usr/bin/ntpdate || exit $?
$HOST_PREFIX-strip $abspath/$MNT/usr/bin/ntpdate
