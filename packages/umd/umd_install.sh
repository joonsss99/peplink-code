#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

DESTDIR=${abspath}/${MNT}/usr/local/ilink/bin

mkdir -p ${DESTDIR}
cp ${FETCHEDDIR}/umd ${DESTDIR}/ || exit 1
${HOST_PREFIX}-strip ${DESTDIR}/umd || exit 1

inittab_install ${abspath} add respawn "/usr/local/ilink/bin/umd"

