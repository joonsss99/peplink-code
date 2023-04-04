#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ./${PACKAGESDIR}/common/common_functions

abspath=`pwd`

touch $FETCHEDDIR/web/.config

fmk="-f $PROJECT_MAKE/Makefile"
make $fmk -C $FETCHEDDIR/web CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS all || exit $?
