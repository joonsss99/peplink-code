#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR || exit 1

if [ ! -f configure ]; then
	autoreconf -ivf
fi

if [ ! -f Makefile ] ; then
	./configure --host=$HOST_PREFIX --prefix=/usr || exit $?
fi

make $MAKE_OPTS || exit $?
