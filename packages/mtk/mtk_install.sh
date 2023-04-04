#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

# -------------- Wifi Drivers --------------
makeflag="-C ${KERNEL_SRC} \
	CROSS_COMPILE=${HOST_PREFIX}- \
	ARCH="${KERNEL_ARCH}" \
	DEPMOD="${HOST_TOOL_DEPMOD}" \
	INSTALL_MOD_PATH="$abspath/$MNT" \
	INSTALL_MOD_STRIP=1"

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	makeflag="$makeflag O=$KERNEL_OBJ"
fi

mt_wifi_ap=${abspath}/${FETCHEDDIR}/package/kernel/wlan_driver/jedi/driver/mt_wifi_ap
make ${makeflag} M=${mt_wifi_ap} modules_install || exit $?

wifi_coex=${abspath}/${FETCHEDDIR}/package/kernel/wlan_daemon/wifi_coexistence
make ${makeflag} M=${wifi_coex} modules_install || exit $?

warp=${abspath}/${FETCHEDDIR}/package/kernel/wlan_driver/jedi/warp_driver/warp
make ${makeflag} M=${warp} modules_install || exit $?

# -------------- Cellular Drivers --------------
# Prebuilt libmipc_msg.so
mkdir -p ${MNT}/usr/lib
libmipc=${FETCHEDDIR}/package/libs/mipc/files
cp -f ${libmipc}/libmipc_msg.so ${MNT}/usr/lib/ || exit $?
${HOST_PREFIX}-strip ${MNT}/usr/lib/libmipc_msg.so || exit $?

# libccci
libccci=${FETCHEDDIR}/package/libs/libccci/src
cp -f ${libccci}/libccci.so ${MNT}/usr/lib || exit $?
${HOST_PREFIX}-strip ${MNT}/usr/lib/libccci.so || exit $?

# alsa-lib
alsalib=${FETCHEDDIR}/prebuilt/openwrt-dl/alsa-lib-1.1.8/src/.libs
cp -af ${alsalib}/libasound.so* ${MNT}/usr/lib || exit $?
${HOST_PREFIX}-strip ${MNT}/usr/lib/libasound.so* || exit $?

# libdtmf_detect
libdtmfdetect=${FETCHEDDIR}/package/system/audio/libdtmf_detect
cp -f ${libdtmfdetect}/libdtmf_detect.so ${MNT}/usr/lib || exit $?
${HOST_PREFIX}-strip ${MNT}/usr/lib/libdtmf_detect.so || exit $?

# json-c-0.12.1
jsonc=${FETCHEDDIR}/prebuilt/openwrt-dl/json-c-0.12.1/.libs
cp -af ${jsonc}/libjson-c.so* ${MNT}/usr/lib || exit $?
${HOST_PREFIX}-strip ${MNT}/usr/lib/libjson-c.so* || exit $?

# lua
lua=${FETCHEDDIR}/prebuilt/openwrt-dl/lua-5.1.5/src
cp -af ${lua}/liblua.so* ${MNT}/usr/lib || exit $?
${HOST_PREFIX}-strip ${MNT}/usr/lib/liblua.so* || exit $?

# libubox
mkdir -p ${MNT}/lib
libubox=${FETCHEDDIR}/prebuilt/openwrt-dl/libubox-2020-05-25-66195aee
cp -f ${libubox}/libubox.so ${MNT}/lib || exit $?
${HOST_PREFIX}-strip ${MNT}/lib/libubox.so || exit $?

# mtk_nvram
mtknvram=${FETCHEDDIR}/package/system/mtk_nvram/src
cp -af ${mtknvram}/lib*.so ${MNT}/usr/lib || exit $?
${HOST_PREFIX}-strip ${MNT}/usr/lib/lib*.so || exit $?

# uci
uci=${FETCHEDDIR}/prebuilt/openwrt-dl/uci-2019-09-01-415f9e48
cp -f ${uci}/libuci.so ${MNT}/lib || exit $?
${HOST_PREFIX}-strip ${MNT}/lib/libuci.so || exit $?

# Prebuilt atcli
mkdir -p ${MNT}/usr/bin
atcli=${FETCHEDDIR}/cei/package/cri/radio-cli/files
cp -f ${atcli}/atcli ${MNT}/usr/bin || exit $?
${HOST_PREFIX}-strip ${MNT}/usr/bin/atcli || exit $?

# Prebuilt libcri_client.so
libcri=${FETCHEDDIR}/cei/package/cri/radio-interface/files
cp -f ${libcri}/libcri_client.so ${MNT}/usr/lib || exit $?
${HOST_PREFIX}-strip ${MNT}/usr/lib/libcri_client.so || exit $?

# Prebuilt cricli
cricli=${FETCHEDDIR}/cei/package/cri/radio-cli/files
cp -f ${cricli}/cricli ${MNT}/usr/bin || exit $?
${HOST_PREFIX}-strip ${MNT}/usr/bin/cricli || exit $?

# Prebuilt mipc_wan_cli
mipcwancli=${FETCHEDDIR}/package/network/utils/mipc-wan/files
cp -f ${mipcwancli}/mipc_wan_cli ${MNT}/usr/bin || exit $?
${HOST_PREFIX}-strip ${MNT}/usr/bin/mipc_wan_cli || exit $?

# ccci_fsd
cccifsd=${FETCHEDDIR}/package/system/ccci_fsd/src
cp -f ${cccifsd}/ccci_fsd ${MNT}/usr/bin || exit $?
${HOST_PREFIX}-strip ${MNT}/usr/bin/ccci_fsd || exit $?

# ccci_mdinit
cccimdinit=${FETCHEDDIR}/package/system/ccci_mdinit/src
cp -f ${cccimdinit}/ccci_mdinit ${MNT}/usr/bin || exit $?
${HOST_PREFIX}-strip ${MNT}/usr/bin/ccci_mdinit || exit $

# libtrm
libtrm=${FETCHEDDIR}/package/libs/libtrm/lib/out
cp -f ${libtrm}/libtrm.so ${MNT}/usr/lib || exit $?
${HOST_PREFIX}-strip ${MNT}/usr/lib/libtrm.so || exit $?

# --------------------- GPS Drivers -----------------------
# conninfra
conninfra=${abspath}/${FETCHEDDIR}/package/kernel/connectivity/conninfra
make ${makeflag} M=${conninfra} modules_install || exit $?

# gps_drv
gps_drv=${abspath}/${FETCHEDDIR}/package/kernel/connectivity/gps
make ${makeflag} M=${gps_drv} modules_install || exit $?

# Prebuilt libmnl_gnss.so
gps=${FETCHEDDIR}/package/system/connectivity/gps/mtk_mnld/mnl/openwrt
cp -f ${gps}/aarch64/libmnl_gnss.so ${MNT}/usr/lib/libmnl_gnss.so.0 || exit $?
${HOST_PREFIX}-strip ${MNT}/usr/lib/libmnl_gnss.so.0 || exit $?
ln -sf libmnl_gnss.so.0 ${MNT}/usr/lib/libmnl_gnss.so || exit $?
