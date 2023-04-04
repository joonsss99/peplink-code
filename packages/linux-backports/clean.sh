#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

make -C $FETCHEDDIR KLIB_BUILD=$KERNEL_OBJ clean
