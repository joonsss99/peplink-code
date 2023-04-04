#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

make -f $PROJECT_MAKE/Makefile -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$abspath/$MNT install
