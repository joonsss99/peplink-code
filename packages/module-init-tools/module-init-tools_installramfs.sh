#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

DESTDIR=${RAMFS_ROOT}/sbin

. ${PACKAGESDIR}/common/common_functions

[ ! -f ${FETCHEDDIR}/build/modprobe ] && exit 1

mkdir -p ${DESTDIR}
cp -pf ${FETCHEDDIR}/build/modprobe ${DESTDIR}/
cp -pf ${FETCHEDDIR}/build/insmod ${DESTDIR}/
cp -pf ${FETCHEDDIR}/build/rmmod ${DESTDIR}/
cp -pf ${FETCHEDDIR}/build/lsmod ${DESTDIR}/

$HOST_PREFIX-strip ${DESTDIR}/modprobe
$HOST_PREFIX-strip ${DESTDIR}/insmod
$HOST_PREFIX-strip ${DESTDIR}/rmmod
$HOST_PREFIX-strip ${DESTDIR}/lsmod

