#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

fmk="-f $PROJECT_MAKE/Makefile"

make $fmk -C $FETCHEDDIR empty_defconfig
make $fmk -C $FETCHEDDIR ${TARGET_SERIES}_defconfig
make $fmk -C $FETCHEDDIR/src \
	DOTCONFIG_DIR=.. \
	CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS || exit $?
