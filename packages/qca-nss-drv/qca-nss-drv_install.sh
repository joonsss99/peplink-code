#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
QCA_NSS_DP_DIR=${abspath}/${FETCHDIR}/qca-nss-dp

makeflag="CROSS_COMPILE=${HOST_PREFIX}- \
	ARCH="${KERNEL_ARCH}" \
	DEPMOD="${HOST_TOOL_DEPMOD}" \
	SUBDIRS=${abspath}/${FETCHEDDIR} \
	EXTRA_CFLAGS=-I${QCA_NSS_DP_DIR}/exports/ \
	KBUILD_EXTRA_SYMBOLS=${QCA_NSS_DP_DIR}/Module.symvers \
	INSTALL_MOD_PATH="$abspath/$MNT" \
	INSTALL_MOD_STRIP=1 \
	SoC=ipq807x"

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	makeflag="$makeflag O=$KERNEL_OBJ"
fi

make -C ${KERNEL_SRC} $makeflag modules_install || exit $?
