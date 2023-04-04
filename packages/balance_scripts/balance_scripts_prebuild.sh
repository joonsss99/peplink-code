#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`


if [ ! -d ${FETCHEDDIR}/etc ]; then
echo "${PACKAGE}: ${FETCHEDDIR}/etc - no such directory"
exit 1
fi


[ ! -d ${abspath}/${MNT}/etc ] && (mkdir -p ${abspath}/${MNT}/etc)
cp -f ${FETCHEDDIR}/etc/inittab ${abspath}/${MNT}/etc || exit 1

