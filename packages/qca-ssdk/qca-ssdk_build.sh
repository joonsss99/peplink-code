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

KERNEL_VER=$(make -s --no-print-directory -C $KERNEL_SRC $makeflag kernelrelease)
GCC_VERSION=$(${HOST_PREFIX}-gcc --version | grep ${HOST_PREFIX}-gcc | sed 's/^.* //g')

make -C ${FETCHEDDIR} \
	  TOOL_PATH="${TOOLCHAIN_BASE_PATH}/${TOOLCHAIN_VERSION}/${HOST_PREFIX}/bin" \
	  KERNEL_SRC="${KERNEL_SRC}" \
	  SYS_PATH="${KERNEL_SRC}" \
	  TARGET_NAME="${HOST_PREFIX}" \
	  TOOLPREFIX="${HOST_PREFIX}-" \
	  KVER="${KERNEL_VER}" \
	  ARCH="${KERNEL_ARCH}" \
	  GCC_VERSION="${GCC_VERSION}" \
	  PTP_FEATURE="enable" \
	  HK_CHIP="enable" \
	  PRJ_PATH="${abspath}/${FETCHEDDIR}" \
	  EXTRA_CFLAGS="-DPEPLINK_FEATURES" \
	  ${makeflag} || exit $?
