#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cp -pf ${FETCHEDDIR}/cryptsetup ${abspath}/${RAMFS_ROOT}/bin/ || exit $?
$HOST_PREFIX-strip $abspath/$RAMFS_ROOT/bin/cryptsetup || exit $?
