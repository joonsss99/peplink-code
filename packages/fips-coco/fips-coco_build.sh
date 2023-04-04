#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

base=$FETCHEDDIR/coco
pepos_runtime=$FETCHEDDIR/pepos

# kernel module
tar -c -C $base/include -f - . | tar -x -C $STAGING/usr/include -f -

make -C $pepos_runtime ARCH=$KERNEL_ARCH CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS || exit $?

mkdir -p $STAGING/usr/include/fips
cp $pepos_runtime/fips_runtime.h $STAGING/usr/include/fips/ || exit $?
