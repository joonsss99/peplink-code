#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

make -C $KERNEL_SRC M=$PWD/$FETCHEDDIR/kernel/linux/ena O=$KERNEL_OBJ $MAKE_OPTS modules || exit 1
