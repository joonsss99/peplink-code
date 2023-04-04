#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

cd "${FETCHEDDIR}/updatedd-2.6" || exit $?
if [ -f Makefile ]; then
	make distclean || exit $?
fi
