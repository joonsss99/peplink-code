#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

make -f $PROJECT_MAKE/Makefile -C $FETCHEDDIR clean
