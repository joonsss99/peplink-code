#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`


cp -Ppf $STAGING/usr/lib/liblber*.so* $abspath/$MNT/usr/lib/
cp -Ppf $STAGING/usr/lib/libldap*.so* $abspath/$MNT/usr/lib/

$HOST_PREFIX-strip $abspath/$MNT/usr/lib/liblber*.so* $abspath/$MNT/usr/lib/libldap*.so*
