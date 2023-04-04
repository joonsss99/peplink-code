#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
cfgfile=pismolabs_config
cfgfile_mesh=pismolabs_config_mesh

# FIXME!!! cant rebuild without clean
# clean hostapd
make -C ${FETCHEDDIR}/hostapd clean

# clean wpa-supplicant
make -C ${FETCHEDDIR}/wpa_supplicant clean

if [ "$BLD_CONFIG_KERNEL_V4_9" = "y" ]; then
	EXTRA_CFLAGS_HOST="-I$STAGING/usr/include/libnl3 \
		-I$STAGING/usr/include \
		-DCONFIG_PISMO_RADIUS_STATISTICS=y \
		-DCONFIG_PISMO_NL80211=y"

	EXTRA_CFLAGS_WPA="-I$STAGING/usr/include/libnl3 \
		-I$STAGING/usr/include \
		-DCONFIG_PISMO_NL80211=y"
else
	EXTRA_CFLAGS_HOST="-I$STAGING/usr/include/libnl3 \
		-I$STAGING/usr/include \
		-DCONFIG_PISMO_RADIUS_STATISTICS=y"

	EXTRA_CFLAGS_WPA="-I$STAGING/usr/include/libnl3 \
		-I$STAGING/usr/include"
fi

if [ "$BLD_CONFIG_QSDK_DRIVER" = "y" ]; then
	EXTRA_CFLAGS_HOST+=" -DCONFIG_PISMO_QSDK_ADD_IFACE_WITH_MAC=y \
			     -DCONFIG_PISMO_QSDK_VAP_SET_RTS_THRESHOLD=y"
fi

# enable shared memory info exchange between hostap + wpa_supplicant
if [ "$BLD_CONFIG_HOSTAP_PTHREAD" = "y" ]; then
	EXTRA_LDFLAGS_HOST="-lpthread"
	EXTRA_CFLAGS_HOST+=" -DCONFIG_PISMO_HOSTAP_PTHREAD=y"
	EXTRA_CFLAGS_WPA+=" -DCONFIG_PISMO_HOSTAP_PTHREAD=y"
fi

# build hostapd
cd $abspath/$FETCHEDDIR/hostapd && \
cp -f $cfgfile .config && \
make $MAKE_OPTS \
	EXTRA_CFLAGS="$EXTRA_CFLAGS_HOST" \
	LDFLAGS="-L$STAGING/usr/lib -lpepos_radiuslog -lpepos $EXTRA_LDFLAGS_HOST" \
	CC=${HOST_PREFIX}-gcc || exit $?

# build wpa-supplicant
cd $abspath/$FETCHEDDIR/wpa_supplicant && \
cp -f $cfgfile .config && \
if [ "$BLD_CONFIG_WIFI_MESH" = "y" -a -f "$cfgfile_mesh" ]; then cat $cfgfile_mesh >> .config ; fi && \
make $MAKE_OPTS \
	EXTRA_CFLAGS="$EXTRA_CFLAGS_WPA" \
	LDFLAGS="-L$STAGING/usr/lib -lpepos_radiuslog -lpepos $EXTRA_LDFLAGS_HOST" \
	CC=${HOST_PREFIX}-gcc || exit $?
