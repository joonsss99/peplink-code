#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cp -pf $FETCHEDDIR/src/grep $abspath/$RAMFS_ROOT/usr/bin/ || exit $?
$HOST_PREFIX-strip $abspath/$RAMFS_ROOT/usr/bin/grep || exit $?
ln -snf grep $abspath/$RAMFS_ROOT/usr/bin/egrep || exit $?

