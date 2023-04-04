#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ -f $FETCHEDDIR/expat/Makefile ] ; then
	make -C ${FETCHEDDIR}/expat distclean
fi
rm -f ${FETCHEDDIR}/expat/configure
