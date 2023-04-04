#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

mkdir -p ${abspath}/${MNT}/usr/local/ilink/bin/keepalived

# Prepare the Binaries
cp -p ${FETCHEDDIR}/bin/keepalived ${abspath}/${MNT}/usr/bin
