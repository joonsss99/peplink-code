#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

#only work for linux
if [ -f $FETCHEDDIR/Makefile ] ; then
	make -C $FETCHEDDIR clean
fi
