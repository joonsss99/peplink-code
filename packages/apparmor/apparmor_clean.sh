#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

make -C "${FETCHEDDIR}" clean || exit $?
if [ -f "${FETCHEDDIR}/libraries/libapparmor/Makefile" ]; then
	make -C "${FETCHEDDIR}/libraries/libapparmor" distclean || exit $?
fi
