#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ ! -f $KERNEL_OBJ/.config ]; then
	echo "${PACKAGE}: kernel .config file is missing"
	exit 1
fi

QCA_NSS_DRV_DIR=${abspath}/${FETCHDIR}/qca-nss-drv
QCA_NSS_CFI_DIR=${abspath}/${FETCHDIR}/qca-nss-cfi
QCA_NSS_CRYPTO_DIR=${abspath}/${FETCHDIR}/qca-nss-crypto
CFI_CRYPTOAPI_DIR=cryptoapi/v2.0

if [ ! -d ${QCA_NSS_DRV_DIR} ]; then
	echo "${PACKAGE}: ${QCA_NSS_DP_DIR} directory is missing"
	exit 1
fi

if [ ! -d ${QCA_NSS_CRYPTO_DIR} ]; then
	echo "${PACKAGE}: ${QCA_NSS_CRYPTO_DIR} directory is missing"
	exit 1
fi

if [ ! -d ${QCA_NSS_CFI_DIR} ]; then
	echo "${PACKAGE}: ${QCA_NSS_CFI_DIR} directory is missing"
	exit 1
fi

EXTRA_CFLAGS="-I${QCA_NSS_DRV_DIR}/exports/ \
	-I${QCA_NSS_CRYPTO_DIR}/v2.0/include \
	-I${QCA_NSS_CFI_DIR}/cryptoapi/exports \
	-I${QCA_NSS_CFI_DIR}/include"

makeflag="CROSS_COMPILE=${HOST_PREFIX}- \
	 ARCH=${KERNEL_ARCH} \
	 SUBDIRS=${abspath}/${FETCHEDDIR} \
         INSTALL_MOD_PATH=$abspath/$MNT \
	 KBUILD_EXTRA_SYMBOLS=${QCA_NSS_CRYPTO_DIR}/Module.symvers \
	 CFI_CRYPTOAPI_DIR=${CFI_CRYPTOAPI_DIR} \
	 SoC=ipq60xx_ipq807x_64"

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	makeflag="$makeflag O=$KERNEL_OBJ"
fi

cd $abspath
make -C $KERNEL_SRC $makeflag EXTRA_CFLAGS="$EXTRA_CFLAGS" modules || exit $?
