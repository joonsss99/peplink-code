#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cp -pf ${FETCHEDDIR}/smartmontools/smartctl ${abspath}/${MNT}/usr/bin/
${HOST_PREFIX}-strip --remove-section=.note --remove-section=.comment ${abspath}/${MNT}/usr/bin/smartctl
