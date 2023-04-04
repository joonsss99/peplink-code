#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR

# since Makefile is replaced by Makefile.in after configure and
# original Makfile doesn't have "clean" target. We will test that
# and if fail to dry-run "clean", we will run configure
if ! make -n clean ; then
	CHOST=$HOST_PREFIX  prefix=/usr ./configure || exit $?
fi

make $MAKE_OPTS || exit $?
make DESTDIR=./_install install || exit $?
make DESTDIR=$STAGING install || exit $?
