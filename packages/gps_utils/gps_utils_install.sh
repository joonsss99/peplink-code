#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cp -Rpf ${FETCHEDDIR}/build/* ${abspath}/${MNT}/ > /dev/null
