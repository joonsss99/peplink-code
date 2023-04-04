#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd ${FETCHEDDIR} || exit $?
if [ ! -f Makefile ] ; then
	./configure --host=$HOST_PREFIX --prefix=/usr || exit $?
fi

make $MAKE_OPTS || exit $?
