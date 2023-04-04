#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

PARTED_BIN="${FETCHEDDIR}/parted/parted"

$HOST_PREFIX-strip ${PARTED_BIN} || exit $?
mkdir -p ${abspath}/${MNT}/usr/bin || exit $?
cp -dpf ${PARTED_BIN} ${abspath}/${MNT}/usr/bin/ || exit $?
