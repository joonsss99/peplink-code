#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

make -C $FETCHEDDIR/userspace/ebtables2 CC=$HOST_PREFIX-gcc LIBDIR="/usr/lib/ebtables" LD=$HOST_PREFIX-ld CFLAGS=${MYCFLAGS} KERNEL_INCLUDES=$STAGING/usr/include
