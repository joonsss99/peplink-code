#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

mkdir -p $abspath/$MNT/usr/bin
cp -f $abspath/$FETCHEDDIR/horst $abspath/$MNT/usr/bin/ || exit $?
${HOST_PREFIX}-strip $abspath/$MNT/usr/bin/horst || exit $?

mkdir -p $abspath/$MNT/etc
touch $abspath/$MNT/etc/wifi_probe_support
