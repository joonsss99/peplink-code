#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR || exit $?

make $MAKE_OPTS KERNEL_DIR=${KERNEL_SRC} CC=${HOST_PREFIX}-gcc PEPLINK=1 PREFIX=/usr binaries || exit $?
