#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

mkdir -p ${abspath}/${MNT}/var/run/dpi/summary
mkdir -p ${abspath}/${MNT}/var/run/dpi/monitor
mkdir -p ${abspath}/${MNT}/usr/local/ilink/bin
cp -pf ${FETCHDIR}/${PACKAGE}/packet_inspection  ${abspath}/${MNT}/usr/local/ilink/bin || exit 1
${HOST_PREFIX}-strip ${abspath}/${MNT}/usr/local/ilink/bin/packet_inspection
