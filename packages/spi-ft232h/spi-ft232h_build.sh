#!/bin/sh

PACKAGE=$1

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

arm_or_x86="-DCONFIG_PISMO_FTDI_SPI"
abspath=`pwd`
SPI_FT232H_DRV_DIR=${abspath}/${FETCHDIR}/spi-ft232h

if [ ! -d ${SPI_FT232H_DRV_DIR} ]; then
	echo "${PACKAGE}: ${SPI_FT232H_DRV_DIR} directory is missing"
	exit 1
fi

if [ $BUILD_TARGET = "apx" ]; then
	arm_or_x86="-DCONFIG_PISMO_FTDI_SPI_X86"
fi

makeflag="ARCH=$KERNEL_ARCH \
	CROSS_COMPILE=$HOST_PREFIX- \
	DEPMOD=$HOST_TOOL_DEPMOD \
	M=${SPI_FT232H_DRV_DIR} \
	KBUILD_EXTRA_SYMBOLS=${SPI_FT232H_DRV_DIR}/Module.symvers \
	INSTALL_MOD_PATH=$abspath/$MNT \
	EXTRA_CFLAGS+=$arm_or_x86 \
	INSTALL_MOD_STRIP=1 \
	KDIR=./"

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	makeflag="$makeflag O=$KERNEL_OBJ"
fi

make -C ${KERNEL_SRC} \
	${makeflag} \
	modules || exit $?
