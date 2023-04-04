#!/bin/sh

PACKAGE=$1
FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd ${FETCHEDDIR} 2> /dev/null || return 0
if [ -f Makefile ] ; then
	make distclean
fi
rm -f configure
