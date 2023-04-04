#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

cd "${FETCHEDDIR}" || exit $?
if [ -f Makefile.inc ]; then
	make clean distclean || exit $?
fi
