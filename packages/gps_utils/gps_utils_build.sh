#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd ${FETCHEDDIR}
make CROSSCOMPILER_PREFIX=$HOST_PREFIX- || exit $?
cd ${abspath}
