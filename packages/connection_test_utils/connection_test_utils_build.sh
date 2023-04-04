#!/bin/sh

PACKAGE=$1

. ./make.conf
abspath=`pwd`
. ${PACKAGESDIR}/common/common_functions

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

fmk="-f $PROJECT_MAKE/Makefile"
make $fmk -C $FETCHEDDIR empty_defconfig
make $fmk -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS || exit $?

