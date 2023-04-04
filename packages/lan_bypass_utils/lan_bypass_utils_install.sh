#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cp -pf $FETCHEDDIR/bin/* $abspath/$MNT/usr/local/ilink/bin

