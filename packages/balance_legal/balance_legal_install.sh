#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

mkdir -p ${abspath}/${MNT}/etc/legal/
cp -rf ${FETCHEDDIR}/etc/legal/* ${abspath}/${MNT}/etc/legal/

