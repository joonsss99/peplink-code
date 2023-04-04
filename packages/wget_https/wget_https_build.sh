#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

fmk="-f $PROJECT_MAKE/Makefile"
make $fmk -C $FETCHEDDIR/source empty_defconfig
make $fmk -C $FETCHEDDIR/source CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS || exit $?
make $fmk -C $FETCHEDDIR/source CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$STAGING install-dev || exit $?
