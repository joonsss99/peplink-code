#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
cd ${FETCHEDDIR}
./clean.sh
cd ${abspath}
exit 0

