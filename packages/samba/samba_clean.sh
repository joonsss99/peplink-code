#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

cd "${FETCHEDDIR}/source3" || exit $?
if [ -f Makefile ]; then
	make $MAKE_OPTS distclean || exit $?
fi
rm -f configure
