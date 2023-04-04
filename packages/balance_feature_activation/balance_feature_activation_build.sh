#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

fmk="-f $PROJECT_MAKE/Makefile"
[ "${ALL_MODEL}" = "y" ] && MAKE_OPTS="${MAKE_OPTS} ALL_MODEL=y"

make $fmk -C $FETCHEDDIR ${TARGET_SERIES}_defconfig
make $fmk -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS || exit $?
make $fmk -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$STAGING install-dev || exit $?
