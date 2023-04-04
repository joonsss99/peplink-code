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

QCA_SSDK_DIR=${abspath}/${FETCHDIR}/qca-ssdk
QCA_NSS_DP_DIR=${abspath}/${FETCHDIR}/qca-nss-dp
if [ ! -d ${QCA_SSDK_DIR} ]; then
	echo "${PACKAGE}: ${QCA_SSDK_DIR} directory is missing"
	exit 1
fi

if [ ! -d ${QCA_NSS_DP_DIR} ]; then
	echo "${PACKAGE}: ${QCA_NSS_DP_DIR} directory is missing"
	exit 1
fi

cd ${FETCHEDDIR}/exports/
ln -sf "arch/nss_ipq_807x_60xx_64.h" "nss_arch.h"

makeflag="CROSS_COMPILE=${HOST_PREFIX}- \
	ARCH=${KERNEL_ARCH} \
	SUBDIRS=${abspath}/${FETCHEDDIR} \
	EXTRA_CFLAGS=-I${QCA_NSS_DP_DIR}/exports/ \
	KBUILD_EXTRA_SYMBOLS=${QCA_NSS_DP_DIR}/Module.symvers \
	INSTALL_MOD_PATH=$abspath/$MNT \
	SoC=ipq60xx_ipq807x_64"

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	makeflag="$makeflag O=$KERNEL_OBJ"
fi

cd $abspath
make -C $KERNEL_SRC $makeflag modules || exit $?
