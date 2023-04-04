#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

DESTDIR=${abspath}/${MNT}/bin

mkdir -p ${DESTDIR}
cp -pf ${FETCHEDDIR}/fwupgrade ${DESTDIR}/ || exit $?
$HOST_PREFIX-strip ${DESTDIR}/fwupgrade
mkdir -p ${abspath}/${MNT}/tmp/tmp
