#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

make -C $FETCHEDDIR CC=${HOST_PREFIX}-gcc STRIP=${HOST_PREFIX}-strip $MAKE_OPTS || exit $?

