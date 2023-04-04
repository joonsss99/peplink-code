#!/bin/sh

PACKAGE=$1

FETCHEDDIR=$FETCHDIR/$PACKAGE

pepos_runtime=$FETCHEDDIR/pepos

make -C $pepos_runtime ARCH=$KERNEL_ARCH CROSS_COMPILE=$HOST_PREFIX- clean
