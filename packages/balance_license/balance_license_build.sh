#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

common_flags="CROSS_COMPILE=$HOST_PREFIX-"

fmk="-f $PROJECT_MAKE/Makefile"

make -C $FETCHEDDIR $fmk empty_defconfig
make -C $FETCHEDDIR $fmk $common_flags || exit $?

make $fmk -C $FETCHEDDIR $common_flags PREFIX=$STAGING/usr install-dev || exit $?

