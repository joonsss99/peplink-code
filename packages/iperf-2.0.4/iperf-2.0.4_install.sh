#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ ! -f ${FETCHEDDIR}/src/iperf ]; then
	echo "missing binary"
	exit 1
fi
$HOST_PREFIX-strip ${FETCHEDDIR}/src/iperf
cp -pf ${FETCHEDDIR}/src/iperf ${abspath}/${MNT}/bin/
