#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

#PL_BUILD_ARCH is defined in balance.profile
fmk="-f $PROJECT_MAKE/Makefile"

if [ "$BUILD_TARGET" != "native_x86" ]; then
export FWKEY_PATH="/etc/fwkey"
fi

make $fmk -C $FETCHEDDIR empty_defconfig
make $fmk -C $FETCHEDDIR ${BUILD_TARGET}_defconfig
if [ "${HOST_MODE}" = "vm" ]; then
	make $fmk -C $FETCHEDDIR CONFIG_EMULATE_CHECK=y CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS || exit $?
else
	make $fmk -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS || exit $?
fi

make $fmk -C $FETCHEDDIR DESTDIR=$STAGING install-dev || exit $?
