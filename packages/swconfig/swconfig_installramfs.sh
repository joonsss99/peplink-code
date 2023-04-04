#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

FMK="-f ${PROJECT_MAKE}/Makefile"

make ${FMK} ${MAKE_OPTS} -C ${FETCHEDDIR} DESTDIR=${abspath}/${RAMFS_ROOT} CROSS_COMPILE=$HOST_PREFIX- install || exit $?
${HOST_PREFIX}-strip ${abspath}/${RAMFS_ROOT}/usr/bin/swconfig || exit $?
