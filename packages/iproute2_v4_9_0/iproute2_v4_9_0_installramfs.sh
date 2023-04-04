#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cp $FETCHEDDIR/ip/ip $abspath/$RAMFS_ROOT/usr/bin/ || exit $?
$HOST_PREFIX-strip $abspath/$RAMFS_ROOT/usr/bin/ip
ln -sf /usr/bin/ip $abspath/$RAMFS_ROOT/bin/ip
