#!/bin/sh

PACKAGE=$1

. ./make.conf
abspath=`pwd`
. ${PACKAGESDIR}/common/common_functions

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

fmk="-f $PROJECT_MAKE/Makefile"
make $fmk -C $FETCHEDDIR clean || exit $?
