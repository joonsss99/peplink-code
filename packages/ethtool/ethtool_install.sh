#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

DESTDIR=${abspath}/${MNT}/sbin

mkdir -p ${DESTDIR}
cp -pf ${FETCHEDDIR}/ethtool ${DESTDIR}/
${HOST_PREFIX}-strip ${DESTDIR}/ethtool || exit $?
