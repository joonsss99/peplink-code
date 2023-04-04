#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`


if [ "${PL_BUILD_ARCH}" == "x86" ]; then
make -C ${FETCHEDDIR} KERNEL_PATH=${KERNEL_DIR} CC=$HOST_PREFIX-gcc STRIP=$HOST_PREFIX-strip clean
else
make -C ${FETCHEDDIR} KERNEL_PATH=${KERNEL_DIR} CROSS_COMPILE_ENABLED=1 CC=$HOST_PREFIX-gcc STRIP=$HOST_PREFIX-strip clean
fi
