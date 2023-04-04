#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

cd ${FETCHEDDIR}
make CROSS_COMPILE=$HOST_PREFIX- distclean || exit $?
