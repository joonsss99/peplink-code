#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

compiler="CROSS_COMPILE=$HOST_PREFIX-"
fmk="-f ${PROJECT_MAKE}/Makefile"
mntdir="${abspath}/${MNT}"
opts="${fmk} ${MAKE_OPTS} -C ${FETCHEDDIR} ${compiler}"

make ${opts} DESTDIR=${mntdir} install || exit $?
mkdir -p ${mntdir}/var/run/hwmon
mkdir -p ${mntdir}/var/run/btalk/data
