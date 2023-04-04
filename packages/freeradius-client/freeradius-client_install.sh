#!/bin/sh

PACKAGE=$1

FETCHEDDIR=$FETCHDIR/$PACKAGE

abspath=`pwd`

mkdir -p $abspath/$MNT/var/run/ilink/radiusclient
cp -f $FETCHEDDIR/etc/* $abspath/$MNT/var/run/ilink/radiusclient
mkdir -p $abspath/$MNT/usr/bin
cp -f $FETCHEDDIR/src/.libs/radiusclient $abspath/$MNT/usr/bin/
$HOST_PREFIX-strip $abspath/$MNT/usr/bin/radiusclient
rm -f $abspath/$MNT/var/run/ilink/radiusclient/Makefile*
mkdir -p $abspath/$MNT/usr/lib
cp -fP $FETCHEDDIR/lib/.libs/libfreeradius-client.so* $abspath/$MNT/usr/lib/
$HOST_PREFIX-strip $abspath/$MNT/usr/lib/libfreeradius-client.so*
