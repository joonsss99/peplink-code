#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
TOOLCHAIN=${TOOLCHAIN_BASE_PATH}/${TOOLCHAIN_VERSION}/${HOST_PREFIX}/bin/${HOST_PREFIX}
PKG_CONFIG_PATH=${STAGING}/usr/lib/pkgconfig

AR="${HOST_PREFIX}-gcc-ar"
AS="${HOST_PREFIX}-gcc -c -Os -pipe -fno-caller-saves -fno-plt -Wno-error=unused-label -funwind-tables -DCEI_RIL -fhonour-copts -Wno-error=unused-but-set-variable -Wno-error=unused-result -Wformat -Werror=format-security -fstack-protector -D_FORTIFY_SOURCE=1 -Wl,-z,now -Wl,-z,relro -fpic"
LD="${HOST_PREFIX}-ld"
NM="${HOST_PREFIX}-gcc-nm"
CC="${HOST_PREFIX}-gcc"
GCC="${HOST_PREFIX}-gcc"
CXX="${HOST_PREFIX}-g++"
RANLIB="${HOST_PREFIX}-gcc-ranlib"
STRIP="${HOST_PREFIX}-strip"
OBJCOPY="${HOST_PREFIX}-objcopy"
OBJDUMP="${HOST_PREFIX}-objdump"
SIZE="${HOST_PREFIX}-size"
CFLAGS="-Os -pipe -fno-caller-saves -fno-plt -Wno-error=unused-label -funwind-tables -DCEI_RIL -fhonour-copts -Wno-error=unused-but-set-variable -Wno-error=unused-result -Wformat -Werror=format-security -fstack-protector -D_FORTIFY_SOURCE=1 -Wl,-z,now -Wl,-z,relro -fpic"

OPT="AR=\"${AR}\" \
	AS=\"${AS}\ \${REMAP}\" \
	LD=\"${LD}\" \
	NM=\"${NM}\" \
	CC=\"${CC}\" \
	GCC=\"${GCC}\" \
	CXX=\"${CXX}\" \
	RANLIB=\"${RANLIB}\" \
	STRIP=\"${STRIP}\" \
	OBJCOPY=\"${OBJCOPY}\" \
	OBJDUMP=\"${OBJDUMP}\" \
	SIZE=\"${SIZE}\" \
	CFLAGS=\"${CFLAGS} \${REMAP} \${TARGET_CFLAGS}\""

# -------------- Wifi Drivers --------------
fmk="-f $PROJECT_MAKE/Makefile"
jedi=${FETCHEDDIR}/package/kernel/wlan_driver/jedi
make ${fmk} -C ${jedi} ${TARGET_SERIES}_defconfig || exit $?

makeflag="-C ${KERNEL_SRC} \
	CROSS_COMPILE=${HOST_PREFIX}- \
	ARCH=${KERNEL_ARCH}"

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	makeflag="${makeflag} O=${KERNEL_OBJ}"
fi

mt_wifi_ap=${abspath}/${FETCHEDDIR}/package/kernel/wlan_driver/jedi/driver/mt_wifi_ap
make ${makeflag} M=${mt_wifi_ap} modules || exit $?

wifi_coex=${abspath}/${FETCHEDDIR}/package/kernel/wlan_daemon/wifi_coexistence
make ${makeflag} M=${wifi_coex} modules || exit $?

# Prepare the embedded firmware
warp=${abspath}/${FETCHEDDIR}/package/kernel/wlan_driver/jedi/warp_driver/warp
mkdir -p ${warp}/bin/colgin

fw0=${abspath}/${FETCHEDDIR}/prebuilt/wlan/jedi/bin/mt6890/colgin_WOCPU0_RAM_CODE_release.bin
fw1=${abspath}/${FETCHEDDIR}/prebuilt/wlan/jedi/bin/mt6890/colgin_WOCPU1_RAM_CODE_release.bin
ln -sf ${fw0} ${warp}/bin/colgin/colgin_WOCPU0_RAM_CODE_release.bin || exit $?
ln -sf ${fw1} ${warp}/bin/colgin/colgin_WOCPU1_RAM_CODE_release.bin || exit $?
CHIPSET="colgin" make -C ${warp} build_tools || exit $?
make ${makeflag} M=${warp} modules || exit $?

# -------------- Cellular Drivers --------------
# libccci
libccci=${abspath}/${FETCHEDDIR}/package/libs/libccci/src

unset TARGET_CFLAGS
REMAP="-iremap${libccci}:libccci-0.1"
eval "make -C ${libccci} ${OPT} all || exit $?"
mkdir -p ${STAGING}/usr/include
mkdir -p ${STAGING}/usr/lib
cp -f ${libccci}/include/* ${STAGING}/usr/include || exit $?
cp -f ${libccci}/libccci.so ${STAGING}/usr/lib || exit $?

# alsa-lib
alsalib=${abspath}/${FETCHEDDIR}/prebuilt/openwrt-dl/alsa-lib-1.1.8
cd ${alsalib} || exit $?
if [ ! -f Makefile ]; then
	./configure \
		--host=${HOST_PREFIX} \
	        --prefix=/usr \
		--disable-python \
		--without-debug \
		--with-softfloat \
		--with-versioned=no || exit $?
fi

make ${MAKE_OPTS} || exit $?
make DESTDIR=${STAGING} ${MAKE_OPTS} install || exit $?

# libdtmf_detect
libdtmf_detect=${abspath}/${FETCHEDDIR}/package/system/audio/libdtmf_detect
unset TARGET_CFLAGS
REMAP="-iremap${libdtmf_detect}:libdtmf_detect"
eval "make -C ${libdtmf_detect} ${OPT} STAGING_DIR=${STAGING} || exit $?"
cp -f ${libdtmf_detect}/libdtmf_detect.so ${STAGING}/usr/lib || exit $?
cp -f ${libdtmf_detect}/*.h ${STAGING}/usr/include || exit $?

# json-c-0.12.1
jsonc=${abspath}/${FETCHEDDIR}/prebuilt/openwrt-dl/json-c-0.12.1
cd ${jsonc} || exit $?
if [ ! -f configure ]; then
	autoreconf -vif || exit $?
fi

if [ ! -f Makefile ]; then
	REMAP="-iremap${jsonc}:json-c-0.12.1"
	TARGET_CFLAGS="-Wno-error=parentheses -Wno-implicit-fallthrough"
	if [ "${HOST_PREFIX}" = "aarch64-openwrt-linux-musl" ]; then
		config_flag="ac_cv_func_realloc_0_nonnull=yes ac_cv_func_malloc_0_nonnull=yes"
	else
		config_flag=""
	fi
	eval "${config_flag} ${OPT} ./configure \
		--host=${HOST_PREFIX} \
		--prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var || exit $?"
fi
make ${MAKE_OPTS} || exit $?
make DESTDIR=${STAGING}/mtk ${MAKE_OPTS} install || exit $?

# lua
lua=${abspath}/${FETCHEDDIR}/prebuilt/openwrt-dl/lua-5.1.5
cd ${lua} || exit $?
REMAP="-iremap${lua}:liblua-5.1.5"
TARGET_CFLAGS="-DLUA_USE_LINUX -std=gnu99"
LDFLAGS="-L${STAGING}/usr/lib -L${STAGING}/lib"
eval "make ${OPT} LDFLAGS=\"${LDFLAGS}\" \
	AR=\"${AR} rcu\" \
	PKG_VERSION=5.1.5 \
	linux || exit $?"
make INSTALL_TOP=${STAGING}/usr ${MAKE_OPTS} install || exit $?

# libubox
libubox=${abspath}/${FETCHEDDIR}/prebuilt/openwrt-dl/libubox-2020-05-25-66195aee

TARGET_CFLAGS="-Os -pipe -I${STAGING}/usr/include -I${STAGING}/mtk/usr/include"
TARGET_CXXFLAGS="${TARGET_CFLAGS}"
TARGET_LDFLAGS="-L${STAGING}/usr/lib -L${STAGING}/lib"
CMAKE_SHARED_LDFLAGS="-Wl,-Bsymbolic-functions"

cd ${libubox} || exit $?
cmakeflags="-DCMAKE_SYSTEM_NAME=Linux \
-DCMAKE_SYSTEM_VERSION=1 \
-DCMAKE_SYSTEM_PROCESSOR=${BLD_CONFIG_ARCH} \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_C_FLAGS_RELEASE=-DNDEBUG \
-DCMAKE_C_COMPILER=${TOOLCHAIN}-gcc \
-DCMAKE_C_COMPILER_ARG1=\"\" \
-DCMAKE_EXE_LINKER_FLAGS:STRING=\"${TARGET_LDFLAGS}\" \
-DCMAKE_MODULE_LINKER_FLAGS:STRING=\"${TARGET_LDFLAGS} ${CMAKE_SHARED_LDFLAGS}\" \
-DCMAKE_SHARED_LINKER_FLAGS:STRING=\"${TARGET_LDFLAGS} ${CMAKE_SHARED_LDFLAGS}\" \
-DCMAKE_AR=${TOOLCHAIN}-ar \
-DCMAKE_NM=${TOOLCHAIN}-nm \
-DCMAKE_RANLIB=${TOOLCHAIN}-ranlib \
-DCMAKE_FIND_ROOT_PATH=\"${STAGING}/usr;${STAGING};${STAGING}/mtk;${STAGING}/mtk/usr\" \
-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=BOTH \
-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
-DCMAKE_STRIP=${TOOLCHAIN}-strip \
-DCMAKE_INSTALL_PREFIX=${STAGING}/usr \
-DCMAKE_PREFIX_PATH=${STAGING} \
-DCMAKE_SKIP_RPATH=TRUE \
-DLUAPATH=${STAGING}/usr/lib/lua"

eval "PKG_CONFIG_SYSROOT_DIR=${STAGING}/mtk \
	PKG_CONFIG_PATH=${STAGING}/mtk/usr/lib/pkgconfig \
	CFLAGS=\"${TARGET_CFLAGS}\" \
        CXXFLAGS=\"${TARGET_CXXFLAGS}\" \
        LDFLAGS=\"${TARGET_LDFLAGS}\" \
        cmake ${cmakeflags} . || exit $?"

make ${MAKE_OPTS} || exit $?
make ${MAKE_OPTS} install || exit $?

# mtk_nvram
mtknvram=${abspath}/${FETCHEDDIR}/package/system/mtk_nvram/src
cd ${mtknvram} || exit $?
CC=${HOST_PREFIX}-gcc \
	CFLAGS="${TARGET_CFLAGS} -Wall" \
	LDFLAGS="${TARGET_LDFLAGS}" \
	STAGING_DIR=${STAGING} \
	make ${MAKE_OPTS} || exit $?
cp -f lib*.so ${STAGING}/usr/lib || exit $?

# uci
uci=${abspath}/${FETCHEDDIR}/prebuilt/openwrt-dl/uci-2019-09-01-415f9e48
cd ${uci} || exit $?
eval "PKG_CONFIG_SYSROOT_DIR=${STAGING} \
	PKG_CONFIG_PATH=${PKG_CONFIG_PATH} \
	CFLAGS=\"${TARGET_CFLAGS}\" \
	CXXFLAGS=\"${TARGET_CXXFLAGS}\" \
	LDFLAGS=\"${TARGET_LDFLAGS}\" \
	cmake ${cmakeflags} . || exit $?"

make ${MAKE_OPTS} || exit $?
make ${MAKE_OPTS} install || exit $?

# ccci_fsd
cccifsd=${abspath}/${FETCHEDDIR}/package/system/ccci_fsd/src
cd ${cccifsd} || exit $?
CC=${HOST_PREFIX}-gcc \
	CFLAGS="${TARGET_CFLAGS} -Wall" \
	LDFLAGS="${TARGET_LDFLAGS}" \
	make ${MAKE_OPTS} || exit $?

# ccci_mdinit
cccimdinit=${abspath}/${FETCHEDDIR}/package/system/ccci_mdinit/src
cd ${cccimdinit} || exit $?
make ${MAKE_OPTS} CC=${HOST_PREFIX}-gcc \
	CFLAGS="${TARGET_CFLAGS} -Wall" \
	LDFLAGS="${TARGET_LDFLAGS}" \
	LIBS="${TARGET_LDFLAGS} -lccci -luci -lubox" || exit $?

# libtrm
libtrm=${abspath}/${FETCHEDDIR}/package/libs/libtrm/lib
cd ${libtrm} || exit $?
unset TARGET_CFLAGS
REMAP="-iremap${libtrm}:libtrm"
eval "make -C ${libtrm} ${OPT} OPENWRT=1 || exit $?"

# --------------------- GPS Drivers -----------------------
# conninfra
conninfra=${abspath}/${FETCHEDDIR}/package/kernel/connectivity/conninfra
cd ${conninfra} || exit $?
extra="-DCFG_CONNINFRA_UT_SUPPORT=1 \
-DCFG_CONNINFRA_DBG_SUPPORT=1 \
-DCFG_CONNINFRA_POWER_STATUS_SUPPORT=1 \
-DCFG_CONNINFRA_BUS_HANG_DEBUG_SUPPORT=1 \
-DCFG_CONNINFRA_PMIC_SUPPORT=1 \
-DCFG_CONNINFRA_THERMAL_SUPPORT=1 \
-DCFG_CONNINFRA_DEVAPC_SUPPORT=0 \
-DCFG_CONNINFRA_COREDUMP_SUPPORT=0 \
-DCFG_CONNINFRA_FW_LOG_SUPPORT=0 \
-DCFG_CONNINFRA_STEP_SUPPORT=0 \
-DCFG_CONNINFRA_EMI_SUPPORT=0 \
-DCFG_CONNINFRA_PRE_CAL_BLOCKING=0 \
-DCFG_CONNINFRA_PRE_CAL_SUPPORT=0"

nostdinc="-I${KERNEL_SRC}/drivers/misc/mediatek/include/mt-plat \
-I${KERNEL_SRC}/drivers/misc/mediatek/connectivity/common \
-I${conninfra}/include \
-I${conninfra}/base/include \
-I${conninfra}/core/include \
-I${conninfra}/conf/include \
-I${conninfra}/platform/include \
-I${conninfra}/debug_utility \
-I${conninfra}/debug_utility/step/include \
-I${conninfra}/test/include \
-I${conninfra}/platform/mt6880/include \
-DMTK_CONNINFRA_CLOCK_BUFFER_API_AVAILABLE=1"

extra_kconfig="CONFIG_CONNINFRA_UT_SUPPORT=y \
CONFIG_CONNINFRA_DBG_SUPPORT=y \
CONFIG_CONNINFRA_DEVAPC_SUPPORT=n \
CONFIG_CONNINFRA_COREDUMP_SUPPORT=n \
CONFIG_CONNINFRA_FW_LOG_SUPPORT=n \
CONFIG_CONNINFRA_STEP_SUPPORT=n \
CONFIG_CONNINFRA_POWER_STATUS_SUPPORT=y \
CONFIG_CONNINFRA_BUS_HANG_DEBUG_SUPPORT=y \
CONFIG_CONNINFRA_EMI_SUPPORT=n \
CONFIG_CONNINFRA_PRE_CAL_BLOCKING=n \
CONFIG_CONNINFRA_PRE_CAL_SUPPORT=n \
CONFIG_CONNINFRA_PMIC_SUPPORT=y \
CONFIG_CONNINFRA_THERMAL_SUPPORT=y"

make ${makeflag} M=${conninfra} EXTRA_CFLAGS="${extra}" NOSTDINC_FLAGS="${nostdinc}" ${extra_kconfig} modules || exit $?

# gps_drv
gps_drv=${abspath}/${FETCHEDDIR}/package/kernel/connectivity/gps
cd ${gps_drv} || exit $?

extra="-DCONFIG_MTK_GPS_SUPPORT=1"
nostdinc="-I${KERNEL_SRC}/drivers/misc/mediatek/include/mt-plat \
-I${conninfra}/include \
-I${gps_drv} \
-I${gps_drv}/data_link/inc \
-I${gps_drv}/data_link/linux/inc \
-I${gps_drv}/data_link/link/inc \
-I${gps_drv}/data_link/lib/inc \
-I${gps_drv}/data_link/hal/inc \
-I${gps_drv}/data_link/hw/inc \
-I${gps_drv}/data_link/hw/inc/mt6880 \
-I${gps_drv}/data_link/hw/inc/mt6880/coda_gen \
-I${gps_drv}/data_link_mock/mock/inc \
-DGPS_DL_HAS_CONNINFRA_DRV=1"

extra_kconfig="CONFIG_MTK_GPS_SUPPORT=y"

make ${makeflag} M=${gps_drv} EXTRA_CFLAGS="${extra}" NOSTDINC_FLAGS="${nostdinc}" ${extra_kconfig} modules || exit $?

# GPS library headers
gps=${abspath}/${FETCHEDDIR}/package/system/connectivity/gps/mtk_mnld/mnl/openwrt
cp -af ${gps}/inc/* ${STAGING}/usr/include || exit $?

# Prebuilt libmnl_gnss.so
cp -f ${gps}/aarch64/libmnl_gnss.so ${STAGING}/usr/lib/libmnl_gnss.so.0 || exit $?
ln -sf libmnl_gnss.so.0 ${STAGING}/usr/lib/libmnl_gnss.so || exit $?

# Prebuilt libhotstill.a
cp -f ${gps}/aarch64/libhotstill.a ${STAGING}/usr/lib || exit$?
