#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

fmk="-f $PROJECT_MAKE/Makefile"

make $fmk -C $FETCHEDDIR empty_defconfig
make $fmk -C $FETCHEDDIR ${TARGET_SERIES}_defconfig
make $fmk -C $FETCHEDDIR/lib \
	DOTCONFIG_DIR=.. \
	PREFIX=/usr/ \
	CROSS_COMPILE=$HOST_PREFIX- DESTDIR=${STAGING}/ \
	install-lib || exit $?

