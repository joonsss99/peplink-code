#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

[ ! -f ${FETCHEDDIR}/tcpdump ] && echo "missing binary" && exit 1

cp -Rpf $FETCHEDDIR/tcpdump $abspath/$MNT/usr/sbin/tcpdump || exit $?
$HOST_PREFIX-strip $abspath/$MNT/usr/sbin/tcpdump || exit $?

