#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
DESTDIR=${abspath}/${MNT}/bin

mkdir -p ${DESTDIR}
cp -pf ${FETCHEDDIR}/traceroute/traceroute ${DESTDIR}/
$HOST_PREFIX-strip ${DESTDIR}/traceroute
