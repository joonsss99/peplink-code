#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

binfile=strace

[ ! -f $FETCHEDDIR/$binfile ] && echo "missing binary in $FETCHEDDIR/$binfile" && exit 1

cp -Rpf $FETCHEDDIR/$binfile $abspath/$MNT/usr/bin/$binfile || exit $?
$HOST_PREFIX-strip $abspath/$MNT/usr/bin/$binfile || exit $?

