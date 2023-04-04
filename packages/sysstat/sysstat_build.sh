#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

cd $FETCHEDDIR || exit $?
if [ ! -f Makefile ] ; then
	./configure --host=${HOST_PREFIX} || exit $?
fi
make || exit $?
