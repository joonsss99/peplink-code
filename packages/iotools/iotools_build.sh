#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

compiler="CROSS_COMPILE=$HOST_PREFIX-"
fmk="-f ${PROJECT_MAKE}/Makefile"
common_flags="${fmk} ${compiler} -C ${FETCHEDDIR} ${MAKE_OPTS}"

make ${common_flags} ${TARGET_SERIES}_defconfig || exit $?
make ${common_flags} || exit $?
make ${common_flags} DESTDIR=${STAGING} install-dev || exit $?
