#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

fmk="-f $PROJECT_MAKE/Makefile"

make $fmk -C ${FETCHEDDIR}/src clean || exit $?

