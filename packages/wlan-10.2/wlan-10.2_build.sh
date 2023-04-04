#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

make -C ${FETCHEDDIR} $MAKE_OPTS 11AC_OFFLOAD=1 || exit $?
