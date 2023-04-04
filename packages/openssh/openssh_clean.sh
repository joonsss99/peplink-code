#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ -e $FETCHEDDIR/Makefile ]; then
	make -C ${FETCHEDDIR} clean
	rm -f $FETCHEDDIR/Makefile
	rm -f $FETCHEDDIR/configure
fi
