#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

make -C $FETCHEDDIR BIN_LIB_ONLY="yes" CROSS_COMPILE=$HOST_PREFIX- \
	DESTDIR=$abspath/$MNT/ prefix=/usr install || exit $?
