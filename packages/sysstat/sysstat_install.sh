#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
DESTDIR=${abspath}/${MNT}/usr/bin

mkdir -p ${DESTDIR}
cp ${FETCHEDDIR}/mpstat ${DESTDIR}/ || exit $?
cp ${FETCHEDDIR}/pidstat ${DESTDIR}/ || exit $?
cp ${FETCHEDDIR}/iostat ${DESTDIR}/ || exit $?

${HOST_PREFIX}-strip ${DESTDIR}/mpstat
${HOST_PREFIX}-strip ${DESTDIR}/pidstat
${HOST_PREFIX}-strip ${DESTDIR}/iostat
