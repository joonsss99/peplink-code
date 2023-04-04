#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ -f $FETCHEDDIR/Makefile.peplink ]; then
	make -C ${FETCHEDDIR} -f Makefile.peplink clean
fi
