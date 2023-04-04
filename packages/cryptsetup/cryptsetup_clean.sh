#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

cd "${FETCHEDDIR}" || exit $?
if [ -f Makefile ]; then
	make KERNEL_PATH=${KERNEL_DIR} distclean || exit $?
fi
rm -f configure
