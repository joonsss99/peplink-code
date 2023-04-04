#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

cd ${FETCHEDDIR} || exit $?
[ ! -f Makefile.opts ] || make distclean
