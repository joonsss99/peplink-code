#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd ${FETCHEDDIR}

LIBSTRUTILS_INCLUDE="$STAGING/usr/include"
LIBSTRUTILS_LIB="$STAGING/usr/lib"

make LIBSTRUTILS_INCLUDE=$LIBSTRUTILS_INCLUDE LIBSTRUTILS_LIB=$LIBSTRUTILS_LIB all
[ $? -ne 0 ] && exit 1

make install
[ $? -ne 0 ] && exit 1

exit 0
