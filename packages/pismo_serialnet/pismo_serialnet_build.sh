#!/bin/sh

PACKAGE=$1

. ./make.conf
abspath=`pwd`
. ${PACKAGESDIR}/common/common_functions

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

make build_app -C $FETCHEDDIR \
	CROSS_COMPILE_PREFIX=$HOST_PREFIX- \
	GNU_TARGET_NAME=${PL_BUILD_ARCH}  \
	|| exit $?
