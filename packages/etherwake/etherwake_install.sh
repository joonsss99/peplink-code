#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

[ ! -f ${FETCHEDDIR}/etherwake ] && echo "missing binary" && exit 1

DESTDIR=${abspath}/${MNT}/usr/local/ilink/bin
mkdir -p ${DESTDIR}
cp -Rpf ${FETCHEDDIR}/etherwake ${DESTDIR}/
${HOST_PREFIX}-strip ${DESTDIR}/etherwake
