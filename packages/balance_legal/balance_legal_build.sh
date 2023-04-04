#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ "${BUILD_TARGET}" = "m600" -o "${BUILD_TARGET}" = "m700" -o "${BUILD_TARGET}" = "maxotg" -o "${BUILD_TARGET}" = "maxbr1" -o "${BUILD_TARGET}" = "plsw" -o "${BUILD_TARGET}" = "maxdcs" -o "${BUILD_TARGET}" = "maxbr1ac" ]; then
	EXTRA_FLAG="MAX=1"
fi

#PL_BUILD_ARCH is defined in balance.profile
make -C ${FETCHEDDIR} ${EXTRA_FLAG}

