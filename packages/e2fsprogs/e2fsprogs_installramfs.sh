#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

E_BIN=${FETCHEDDIR}/e2fsck/e2fsck

if [ ! -f ${E_BIN} ]; then
	echo "missing binary"
	exit 1
fi

cp -pf ${E_BIN} ${abspath}/${RAMFS_ROOT}/sbin/
$HOST_PREFIX-strip $abspath/$RAMFS_ROOT/sbin/e2fsck
