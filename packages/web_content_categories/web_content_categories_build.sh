#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

fmk="-f $PROJECT_MAKE/Makefile"
make $fmk -C $FETCHEDDIR/src empty_defconfig || exit $?
make $fmk -C $FETCHEDDIR/src || exit $?
