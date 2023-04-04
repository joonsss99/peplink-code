#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cp $FETCHEDDIR/ip/ip $abspath/$MNT/usr/bin/ || exit $?
cp $FETCHEDDIR/tc/tc $abspath/$MNT/usr/bin/ || exit $?
cp $FETCHEDDIR/bridge/bridge $abspath/$MNT/usr/bin/ || exit $?
$HOST_PREFIX-strip $abspath/$MNT/usr/bin/ip
$HOST_PREFIX-strip $abspath/$MNT/usr/bin/tc
$HOST_PREFIX-strip $abspath/$MNT/usr/bin/bridge

ln -sf /usr/bin/ip $abspath/$MNT/bin/ip

cp $FETCHEDDIR/etc/iproute2/rt_tables $abspath/$MNT/etc/iproute2/rt_tables || exit $?
