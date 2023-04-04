#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

make -C $FETCHEDDIR empty_defconfig
make -C $FETCHEDDIR ${TARGET_SERIES}_defconfig
make -C $FETCHEDDIR ${PL_BUILD_ARCH}_defconfig

if [ "$TARGET_SERIES" != "native" ]; then
	make -C $FETCHEDDIR ARCH=$KERNEL_ARCH CROSS_COMPILE=$HOST_PREFIX- FIPS_COCO_PATH=$abspath/$FETCHDIR/fips-coco $MAKE_OPTS || exit
fi

make -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX $MAKE_OPTS DESTDIR=$STAGING PREFIX=/usr install-dev || exit $?
