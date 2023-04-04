#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cp ${FETCHEDDIR}/src/sled $abspath/$MNT/usr/local/ilink/bin/ || exit $?
$HOST_PREFIX-strip $abspath/$MNT/usr/local/ilink/bin/sled
