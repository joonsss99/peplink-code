#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

common_flags="CROSS_COMPILE=$HOST_PREFIX-"
if [ "$BLD_CONFIG_LINUX_WIRELESS_PACKAGE" = "y" ]; then
	build_flags="ACTION=build DIR_WPA_SUPP=${abspath}/fetched/hostap CONFIG_OS=unix CONFIG_LINUXWIRELESS=y"
else
	build_flags="ACTION=build WLAN_BASE=${WLAN_DIR} DIR_WPA_SUPP=${WLAN_DIR}/apps/wpa_supplicant-0.6.9 CONFIG_OS=unix"
fi

make -C ${FETCHEDDIR} empty_defconfig 2> /dev/null
make -C ${FETCHEDDIR} ${TARGET_SERIES}_defconfig 2> /dev/null

make -C ${FETCHEDDIR} ${build_flags} ${common_flags} $MAKE_OPTS || exit $?
make -C ${FETCHEDDIR} ${build_flags} ${common_flags} DESTDIR=$STAGING install-dev || exit $?
