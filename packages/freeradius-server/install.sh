#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR

destdir=$PWD/pepos-staging

make install R=$destdir || exit $?

mkdir -p $abspath/$MNT/usr/lib/radius

mkdir -p $abspath/$MNT/etc/raddb
mkdir -p $abspath/$MNT/etc/raddb/share
mkdir -p $abspath/$MNT/etc/raddb/modules
mkdir -p $abspath/$MNT/etc/raddb/sites-enabled
mkdir -p $abspath/$MNT/etc/activedirectory
mkdir -p $abspath/$MNT/etc/activedirectory/run

$HOST_PREFIX-strip $destdir/usr/lib/*.so
cp -Ppf $destdir/usr/lib/lib*.so* $abspath/$MNT/usr/lib/
cp -Ppf $destdir/usr/lib/rlm*.so $abspath/$MNT/usr/lib/radius/
cp -pf $destdir/usr/sbin/radiusd $abspath/$MNT/usr/sbin/
$HOST_PREFIX-strip $abspath/$MNT/usr/sbin/radiusd

cp -f share/dictionary.compat $abspath/$MNT/etc/raddb/share
cp -f share/dictionary.microsoft $abspath/$MNT/etc/raddb/share
cp -f share/dictionary.rfc* $abspath/$MNT/etc/raddb/share
cp -f share/dictionary.freeradius*  $abspath/$MNT/etc/raddb/share
