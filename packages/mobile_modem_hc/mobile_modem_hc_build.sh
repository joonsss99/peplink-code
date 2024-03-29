#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

LIBSTRUTILS_INCLUDE="$STAGING/usr/include"
LIBSTRUTILS_LIB="$STAGING/usr/lib"

make -C ${FETCHEDDIR} CC=$HOST_PREFIX-gcc LIBSTRUTILS_INCLUDE=$LIBSTRUTILS_INCLUDE LIBSTRUTILS_LIB=$LIBSTRUTILS_LIB || exit $?
