#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

make $MAKE_OPTS CC=${HOST_PREFIX}-gcc LD=${HOST_PREFIX}-ld AR=${HOST_PREFIX}-ar -C ${FETCHEDDIR} || exit $?
