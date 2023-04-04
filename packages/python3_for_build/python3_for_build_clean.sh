#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

[ -f "${FETCHEDDIR}/Makefile" ] && make -C "${FETCHEDDIR}" distclean

rm -rf "${HOST_TOOL_DIR}/python3"
