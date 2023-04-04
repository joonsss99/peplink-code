#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

make -C ${FETCHEDDIR} CC=${HOST_PREFIX}-gcc $MAKE_OPTS

