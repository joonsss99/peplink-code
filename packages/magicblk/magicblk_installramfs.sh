#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

fmk="-f $PROJECT_MAKE/Makefile"

if [ "$PL_BUILD_ARCH" = "ar7100" -o "$BUILD_TARGET" = "ipq64" -o "$BUILD_TARGET" = "aponeax" ]; then
	make $fmk -C $FETCHEDDIR install CROSS_COMPILE=$HOST_PREFIX- PREFIX=/ DESTDIR=$abspath/$RAMFS_ROOT || exit $?
fi
