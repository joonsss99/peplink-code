#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

mystrip=$HOST_PREFIX-strip

DESTDIR=${abspath}/${MNT}/sbin

mkdir ${DESTDIR}

cp -pf ${FETCHEDDIR}/src/dnrd ${DESTDIR}/ || exit $?
$HOST_PREFIX-strip --remove-section=.note --remove-section=.comment ${DESTDIR}/dnrd || exit $?
