#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
DESTDIR=${abspath}/${RAMFS_ROOT}/bin

mkdir -p ${DESTDIR}
cp -pf ${FETCHEDDIR}/ping ${DESTDIR}/
$HOST_PREFIX-strip ${DESTDIR}/ping
