#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ "$BLD_CONFIG_WIFI" = "y" ]; then
	VNSTAT_PATH=$abspath/$FETCHDIR/wlan_stats/vnstat-1.11/src
	VNSTAT="VNSTAT_PATH=${VNSTAT_PATH}"
	ln -sf ${VNSTAT_PATH} ${FETCHEDDIR}/vnstat
	WLAN_PATH="WLAN_PATH=${WLAN_DIR}/apps/wireless_tools.30/"
else
	VNSTAT=""
	WLAN_PATH=""
fi

if [ "$BUILD_MODEL" = "fh" ]; then
	MAC_INF="eth0"
elif [ "$TARGET_SERIES" = "plsw" ]; then
	MAC_INF="eth1"
else
	# Balance or others
	MAC_INF="br0"
fi

if [ "$BUILD_TARGET" = "apone" ] || [ "$BUILD_TARGET" = "aponeac" ] || [ "$BUILD_TARGET" = "aponeax" ] ; then
	CONTROLLER_MGMT="WLC_MGMT=y"
fi

fmk="-f $PROJECT_MAKE/Makefile"
make $fmk -C $FETCHEDDIR ${TARGET_SERIES}_defconfig
make $fmk -C $FETCHEDDIR \
	$VNSTAT \
	$WLAN_PATH \
	$CONTROLLER_MGMT \
	WAN_IF=$MAC_INF \
	CROSS_COMPILE=$HOST_PREFIX- \
	$MAKE_OPTS || exit $?
