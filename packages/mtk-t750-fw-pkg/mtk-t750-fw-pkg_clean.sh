#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

fmk="-f $PROJECT_MAKE/Makefile"

make $fmk -C $FETCHEDDIR/src clean
