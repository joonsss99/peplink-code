#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd ${FETCHEDDIR}/libdm/ioctl
tar cf - *.so* | tar -C ${abspath}/${RAMFS_ROOT}/lib -xf - || exit 1
$HOST_PREFIX-strip $abspath/$RAMFS_ROOT/lib/libdevmapper.so.*

cd $abspath
