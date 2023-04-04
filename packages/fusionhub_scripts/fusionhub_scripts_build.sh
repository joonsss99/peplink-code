#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

make -C $FETCHEDDIR/src empty_defconfig || exit $?
make -C $FETCHEDDIR/src CC=$HOST_PREFIX-gcc STRIP=$HOST_PREFIX-strip AR=$HOST_PREFIX-ar || exit $?
