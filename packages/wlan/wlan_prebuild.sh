#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
# Prepare make rule file for wlan build
if [ "${PL_BUILD_ARCH}" = "powerpc" ]; then
	KERNEL_VER=3.6.11-pismolabs
	ARCH=${PL_BUILD_ARCH}
else
	KERNEL_VER=2.6.28.10
	ARCH=mips
fi

cat > ${FETCHDIR}/${PACKAGE}/make.rules << EOF
ARCH=${ARCH}
BASE_DIR=${abspath}/${FETCHDIR}
KERNEL_VERSION=${KERNEL_VER}
KERNEL_PATH=${KERNEL_DIR}
KERNEL_HEADERS=${KERNEL_DIR}/include
TARGET_DIR=${abspath}/${MNT}
TARGET_CROSS=$HOST_PREFIX-
AR=$HOST_PREFIX-ar
AS=$HOST_PREFIX-as
LD=$HOST_PREFIX-ld
NM=$HOST_PREFIX-nm
CC=$HOST_PREFIX-gcc
GCC=$HOST_PREFIX-gcc
CPP=$HOST_PREFIX-gcc
CXX=$HOST_PREFIX-g++
STRIP=$HOST_PREFIX-strip
RANLIB=$HOST_PREFIX-ranlib
CFLAGS += -I$STAGING/usr/include
LIBS += -L${STAGING}/usr/lib
LIBS_p += -L${STAGING}/usr/lib
EOF

pushd ${FETCHEDDIR}
ln -snf Makefile.max.inc Makefile.inc
popd
make -C ${FETCHEDDIR}/drivers/wlan_modules prepare
