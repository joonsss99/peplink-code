#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

DESTDIR=$abspath/$MNT/usr/bin

mkdir -p ${DESTDIR}
cp -pf ${FETCHEDDIR}/xargs/xargs ${DESTDIR}/
${HOST_PREFIX}-strip ${DESTDIR}/xargs
