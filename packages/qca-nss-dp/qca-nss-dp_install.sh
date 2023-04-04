#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
QCA_SSDK_DIR=${abspath}/${FETCHDIR}/qca-ssdk

makeflag="CROSS_COMPILE=${HOST_PREFIX}- \
	ARCH=${KERNEL_ARCH} \
	DEPMOD=${HOST_TOOL_DEPMOD} \
	SUBDIRS=${abspath}/${FETCHEDDIR} \
	EXTRA_CFLAGS=\"-I${QCA_SSDK_DIR}/include/ \
		-I${QCA_SSDK_DIR}/include/common/ \
		-I${QCA_SSDK_DIR}/include/sal/os/ \
		-I${QCA_SSDK_DIR}/include/sal/os/linux/ \
		-I${QCA_SSDK_DIR}/include/fal/ \
		-I${KERNEL_SRC}/include/\" \
	KBUILD_EXTRA_SYMBOLS=${QCA_SSDK_DIR}/temp/Module.symvers \
	INSTALL_MOD_PATH=$abspath/$MNT \
	INSTALL_MOD_STRIP=1 \
	SoC=ipq807x"

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	makeflag="$makeflag O=$KERNEL_OBJ"
fi

make -C ${KERNEL_SRC} $makeflag modules_install || exit $?
