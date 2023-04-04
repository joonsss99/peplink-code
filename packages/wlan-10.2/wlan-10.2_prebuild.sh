#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
makeflag="ARCH=$KERNEL_ARCH CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS"

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	makeflag="$makeflag O=$KERNEL_OBJ"
fi

if [ ! -f $KERNEL_OBJ/.config ]; then
	echo "${PACKAGE}: kernel .config file is missing"
	exit 1
fi

# Prepare make rule file for wlan build (doesn't matter for linuxwireless build)
KERNEL_VER=$(make -s --no-print-directory -C $KERNEL_SRC $makeflag kernelrelease)

if [ "${PL_BUILD_ARCH}" = "x86_64" ] || [ "${PL_BUILD_ARCH}" = "x86" ] || \
   [ "${PL_BUILD_ARCH}" = "powerpc" ] || [ "${PL_BUILD_ARCH}" = "arm" ] || \
   [ "${PL_BUILD_ARCH}" = "arm64" ]; then
	ARCH=${PL_BUILD_ARCH}
else
	ARCH=mips
fi

cat > ${FETCHDIR}/${PACKAGE}/make.rules << EOF
ARCH=${ARCH}
BASE_DIR=${abspath}/${FETCHDIR}
KERNEL_VERSION=${KERNEL_VER}
KERNEL_PATH=${KERNEL_DIR}
KERNEL_HEADERS=${KERNEL_DIR}/include
KERNEL_OBJ=${KERNEL_OBJ}
TARGET_DIR=${abspath}/${MNT}
TARGET_CROSS=$HOST_PREFIX-
AR=$HOST_PREFIX-ar
AS=$HOST_PREFIX-as
LD=$HOST_PREFIX-ld
NM=$HOST_PREFIX-nm
CC=$HOST_PREFIX-gcc
GCC=$HOST_PREFIX-gcc
CPP=$HOSt_PREFIX-gcc
CXX=$HOST_PREFIX-g++
STRIP=$HOST_PREFIX-strip
RANLIB=$HOST_PREFIX-ranlib
LIBS += -L${STAGING}/usr/lib
LIBS_p += -L${STAGING}/usr/lib
EOF

if [ "${BLD_CONFIG_LINUX_WIRELESS_PACKAGE}" = "y" ]; then
	if [ "${BUILD_TARGET}" = "ipq" ] || [ "${BUILD_TARGET}" = "apone" ] || [ "${BUILD_TARGET}" = "maxdcs_ipq" ] || [ "${BUILD_TARGET}" = "sfchn" ]; then
		ln -snf Makefile.linuxwireless.ipq.inc ${FETCHEDDIR}/Makefile.inc
	elif [ "${PL_BUILD_ARCH}" = "x86_64" ] || [ "${PL_BUILD_ARCH}" = "x86" ]; then
		ln -snf Makefile.linuxwireless.x86.inc ${FETCHEDDIR}/Makefile.inc
	elif [ "${PL_BUILD_ARCH}" = "arm64" ]; then
		ln -snf Makefile.linuxwireless.qsdk-807x.inc ${FETCHEDDIR}/Makefile.inc
	elif [ "${PL_BUILD_ARCH}" = "ramips" ]; then
		if [ "${BLD_CONFIG_LINUX_BACKPORTS}" = "y" ]; then
			ln -snf Makefile.linuxwireless.mt7621.inc ${FETCHEDDIR}/Makefile.inc
		else
			ln -snf Makefile.linuxwireless.wlan_mt76.inc ${FETCHEDDIR}/Makefile.inc
		fi
	else
		ln -snf Makefile.linuxwireless.inc ${FETCHEDDIR}/Makefile.inc
	fi
elif [ "${BUILD_TARGET}" = "mtk5g" ]; then
	ln -sf Makefile.mtk5g.inc ${FETCHEDDIR}/Makefile.inc
else
	ln -snf Makefile.max.inc ${FETCHEDDIR}/Makefile.inc
	make -C ${FETCHEDDIR}/drivers/wlan_modules prepare
fi
