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
if [ ! -d ${QCA_SSDK_DIR} ]; then
	echo "${PACKAGE}: ${QCA_SSDK_DIR} directory is missing"
	exit 1
fi

makeflag="CROSS_COMPILE=${HOST_PREFIX}- \
	ARCH=${KERNEL_ARCH} \
	M=${abspath}/${FETCHEDDIR} \
	QCA_SSDK_DIR=${QCA_SSDK_DIR} \
	KBUILD_EXTRA_SYMBOLS=${QCA_SSDK_DIR}/build/linux/KSLIB/Module.symvers \
	INSTALL_MOD_PATH=$abspath/$MNT \
	SoC=ipq807x"

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	makeflag="$makeflag O=$KERNEL_OBJ"
fi

make -C $KERNEL_SRC $makeflag modules || exit $?
