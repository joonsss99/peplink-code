#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

binfile=zonenotify

DESTDIR=${abspath}/${MNT}/usr/bin

[ ! -f ${FETCHEDDIR}/${binfile} ] && echo "missing binary in ${FETCHEDDIR}/${binfile}" && exit 1

mkdir -p ${DESTDIR}
cp -Rpf ${FETCHEDDIR}/${binfile} ${DESTDIR}/ || exit $?
${HOST_PREFIX}-strip ${DESTDIR}/${binfile} || exit $?
