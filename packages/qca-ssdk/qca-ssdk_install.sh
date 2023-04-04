#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
makeflag="ARCH=$KERNEL_ARCH CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS DEPMOD=$HOST_TOOL_DEPMOD"

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	makeflag="$makeflag O=$KERNEL_OBJ"
fi

make -C "${KERNEL_SRC}" \
	${makeflag} \
	M="${abspath}/${FETCHEDDIR}/build/linux/KSLIB" \
	INSTALL_MOD_PATH="$abspath/$MNT" \
	INSTALL_MOD_STRIP=1 \
	modules_install || exit $?
