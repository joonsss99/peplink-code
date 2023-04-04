#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cp $FETCHEDDIR/src/cpulimit $abspath/$MNT/usr/local/ilink/bin/

$HOST_PREFIX-strip $abspath/$MNT/usr/local/ilink/bin/cpulimit

