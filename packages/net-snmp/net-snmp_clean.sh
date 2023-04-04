#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions


make -C ${FETCHEDDIR} clean_balance -f Makefile.rules
