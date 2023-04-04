#!/bin/sh

PACKAGE=speedfusion

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

LIBDIRS="libvpnstatus"

. ./make.conf

abspath=`pwd`

common_flags="ARCH=$KERNEL_ARCH CROSS_COMPILE=$HOST_PREFIX-"

make -C $FETCHEDDIR empty_defconfig 2> /dev/null
make -C $FETCHEDDIR ${BUILD_MODEL}_defconfig 2> /dev/null
make -C $FETCHEDDIR $common_flags $MAKE_OPTS $LIBDIRS || exit $?
make -C $FETCHEDDIR $common_flags PREFIX=$STAGING/usr install-demo-web  || exit $?
