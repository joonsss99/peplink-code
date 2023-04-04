#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

#cd ${FETCHEDDIR} || exit $?
cp -f $abspath/$FETCHEDDIR/signalbar $abspath/$MNT/usr/sbin/ || exit 1

$HOST_PREFIX-strip --remove-section=.note --remove-section=.comment $MNT/usr/sbin/signalbar

