#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

cd "${FETCHEDDIR}/src" || exit $?
if [ -f Makefile ]; then
	make distclean || exit $?
fi
rm -f configure
