#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

makeflag="-C ${KERNEL_SRC} \
	CROSS_COMPILE=${HOST_PREFIX}- \
	ARCH=${KERNEL_ARCH}"

pismolabs=$(cat $KERNEL_OBJ/.config | grep CONFIG_MEDIATEK_PISMOLABS_PLATFORM | cut -d'=' -f2)

mt_wifi_ap=${abspath}/${FETCHEDDIR}/package/kernel/wlan_driver/jedi/driver/mt_wifi_ap
M="${mt_wifi_ap} ${mt_wifi_ap}/../mt_wifi/embedded/plug_in"

wifi_coex=${abspath}/${FETCHEDDIR}/package/kernel/wlan_daemon/wifi_coexistence
M="${M} ${wifi_coex}"

warp=${abspath}/${FETCHEDDIR}/package/kernel/wlan_driver/jedi/warp_driver/warp
M="${M} ${warp}"

for m in $M; do
	CONFIG_MEDIATEK_PISMOLABS_PLATFORM=${pismolabs} make ${makeflag} M=${m} clean || exit $?
done

# Remove firmware headers and bin2h
rm -f ${warp}/regs/reg_v2/WO*_firmware.h ${warp}/tools/bin2h || exit $?

# libccci
libccci=${FETCHEDDIR}/package/libs/libccci/src
cd ${libccci} || exit $?
rm -f ./*.o ./*.so ./platform/*.o || exit $?

# alsa-lib
alsalib=${abspath}/${FETCHEDDIR}/prebuilt/openwrt-dl/alsa-lib-1.1.8
if [ -f ${alsalib}/Makefile ]; then
	make -C ${alsalib} clean || exit $?
	rm -f ${alsalib}/Makefile || exit $?
fi

# libdtmf_detect.so
libdtmf_detect=${abspath}/${FETCHEDDIR}/package/system/audio/libdtmf_detect
make -C ${libdtmf_detect} clean || exit $?

# json-c-0.12.1
jsonc=${abspath}/${FETCHEDDIR}/prebuilt/openwrt-dl/json-c-0.12.1
if [ -f ${jsonc}/Makefile ]; then
	make -C ${jsonc} DESTDIR=${abspath}/${MNT} ${MAKE_OPTS} clean || exit $?
	rm -f ${jsonc}/Makefile || exit $?
fi
rm -f ${jsonc}/configure || exit $?

# lua
lua=${abspath}/${FETCHEDDIR}/prebuilt/openwrt-dl/lua-5.1.5
make -C ${lua} clean || exit $?

# libubox
libubox=${abspath}/${FETCHEDDIR}/prebuilt/openwrt-dl/libubox-2020-05-25-66195aee
cd ${libubox} || exit $?
if [ -f Makefile ]; then
	make clean || exit $?
	rm -f Makefile || exit $?
fi
rm -rf ./*.cmake CMakefiles || exit $?

# mtk_nvram
mtknvram=${abspath}/${FETCHEDDIR}/package/system/mtk_nvram/src
make -C ${mtknvram} clean || exit $?

# uci
uci=${abspath}/${FETCHEDDIR}/prebuilt/openwrt-dl/uci-2019-09-01-415f9e48
cd ${uci} || exit $?
if [ -f Makefile ]; then
	make clean || exit $?
	rm -f Makefile || exit $?
fi
rm -rf ./*.cmake CMakefiles || exit $?

# ccci_fsd
cccifsd=${abspath}/${FETCHEDDIR}/package/system/ccci_fsd/src
make -C ${cccifsd} clean || exit $?

# ccci_mdinit
cccimdinit=${abspath}/${FETCHEDDIR}/package/system/ccci_mdinit/src
cd ${cccimdinit} || exit $?
rm -f ./*.o ccci_mdinit || exit $?

# libtrm
libtrm=${abspath}/${FETCHEDDIR}/package/libs/libtrm/lib
cd ${libtrm} || exit $?
rm -rf out || exit $?

# --------------------- GPS Drivers -----------------------
# conninfra
chip=$(cat $KERNEL_OBJ/.config | grep CONFIG_MTK_COMBO_CHIP | cut -d'=' -f2)
conninfra=${abspath}/${FETCHEDDIR}/package/kernel/connectivity/conninfra
CONFIG_MTK_COMBO_CHIP=${chip} make ${makeflag} M=${conninfra} clean || exit $?

# gps_drv
gps_drv=${abspath}/${FETCHEDDIR}/package/kernel/connectivity/gps
make ${makeflag} M=${gps_drv} clean || exit $?
