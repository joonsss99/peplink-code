#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

DESTDIR=${abspath}/${MNT}/usr/bin

mkdir -p ${DESTDIR}
cp -Pp ${FETCHEDDIR}/nc ${DESTDIR}/ || exit $?
${HOST_PREFIX}-strip ${DESTDIR}/nc
