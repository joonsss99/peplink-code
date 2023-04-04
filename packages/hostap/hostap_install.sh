#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

mkdir -p $abspath/$MNT/usr/bin

# install hostapd
cp -f $abspath/$FETCHEDDIR/hostapd/hostapd $abspath/$MNT/usr/bin || exit $?
cp -f $abspath/$FETCHEDDIR/hostapd/hostapd_cli $abspath/$MNT/usr/bin || exit $?

${HOST_PREFIX}-strip $abspath/$MNT/usr/bin/hostapd || exit $?
${HOST_PREFIX}-strip $abspath/$MNT/usr/bin/hostapd_cli || exit $?

# install wpa-supplicant
cp -f $abspath/$FETCHEDDIR/wpa_supplicant/wpa_supplicant $abspath/$MNT/usr/bin || exit $?
cp -f $abspath/$FETCHEDDIR/wpa_supplicant/wpa_cli $abspath/$MNT/usr/bin || exit $?

${HOST_PREFIX}-strip $abspath/$MNT/usr/bin/wpa_supplicant || exit $?
${HOST_PREFIX}-strip $abspath/$MNT/usr/bin/wpa_cli || exit $?
