#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

fmk="-f $PROJECT_MAKE/Makefile"
make $fmk -C $FETCHEDDIR empty_defconfig
make $fmk -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS || exit $?

