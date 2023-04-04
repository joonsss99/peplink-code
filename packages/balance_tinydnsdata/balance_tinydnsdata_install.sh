#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ ! -f ${FETCHEDDIR}/tinydnsdata ]; then
echo "${PACKAGE}: some binaires are missing (incomplete build?)"
exit 1
fi

cp -f ${FETCHEDDIR}/tinydnsdata ${abspath}/${MNT}/usr/local/ilink/bin
cp -f ${FETCHEDDIR}/dns_import ${abspath}/${MNT}/usr/local/ilink/bin

