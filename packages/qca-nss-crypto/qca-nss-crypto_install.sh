#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
QCA_NSS_DRV_DIR=${abspath}/${FETCHDIR}/qca-nss-drv

if [ ! -d ${QCA_NSS_DRV_DIR} ]; then
	echo "${PACKAGE}: ${QCA_NSS_DRV_DIR} directory is missing"
	exit 1
fi

makeflag="CROSS_COMPILE=${HOST_PREFIX}- \
	ARCH=${KERNEL_ARCH} \
	DEPMOD=${HOST_TOOL_DEPMOD} \
	SUBDIRS=${abspath}/${FETCHEDDIR} \
	EXTRA_CFLAGS=-I${QCA_NSS_DRV_DIR}/exports/ \
	INSTALL_MOD_PATH=$abspath/$MNT \
	INSTALL_MOD_STRIP=1"

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	makeflag="$makeflag O=$KERNEL_OBJ"
fi

cd $abspath
make -C $KERNEL_SRC $makeflag modules_install || exit $?
