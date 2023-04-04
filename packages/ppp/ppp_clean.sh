#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

cd "${FETCHEDDIR}" || exit $?
if [ -f Makefile ]; then
	make dist-clean || exit $?
fi
