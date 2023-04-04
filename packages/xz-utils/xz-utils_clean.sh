#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

[ ! -f "${FETCHEDDIR}/Makefile" ] || make -C "${FETCHEDDIR}" distclean || exit $?
