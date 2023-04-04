#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR && cp -Rf raddb/* $abspath/$MNT/etc/raddb/
