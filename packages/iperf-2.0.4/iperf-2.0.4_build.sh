#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

(cd ${FETCHEDDIR}; ./configure host=${HOST_PREFIX})
make -C ${FETCHEDDIR} CC=$HOST_PREFIX-gcc AR=$HOST_PREFIX-ar CXX=$HOST_PREFIX-g++

