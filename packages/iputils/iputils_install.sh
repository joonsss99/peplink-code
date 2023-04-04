#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ "$BLD_CONFIG_IPV6" = "y" ]; then
	UTILS_NAME="ping ping6"
else
	UTILS_NAME="ping"
fi

DESTDIR=${abspath}/${MNT}/bin
mkdir -p ${DESTDIR}
for u in $UTILS_NAME; do
	cp -pf ${FETCHEDDIR}/${u} ${DESTDIR}/ || exit $?
	$HOST_PREFIX-strip ${DESTDIR}/${u} || exit $?
done
