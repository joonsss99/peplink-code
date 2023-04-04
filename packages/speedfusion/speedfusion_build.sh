#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

common_flags="ARCH=$KERNEL_ARCH ILINK_OUT_PATH=$abspath/$FETCHDIR/balance_kmod FIPS_COCO_PATH=$abspath/$FETCHDIR/fips-coco CROSS_COMPILE=$HOST_PREFIX-"

make -C $FETCHEDDIR empty_defconfig 2> /dev/null
make -C $FETCHEDDIR ${TARGET_SERIES}_defconfig 2> /dev/null

make -C $FETCHEDDIR $common_flags $MAKE_OPTS || exit $?
make -C $FETCHEDDIR $common_flags PREFIX=$STAGING/usr install-dev || exit $?
