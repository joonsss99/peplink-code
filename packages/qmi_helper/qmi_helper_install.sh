#!/bin/sh
set -x

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

PROJECT_ABSPATH="${abspath}/${FETCHEDDIR}"

if [ ! -d ${abspath}/${FETCHEDDIR}/build ]; then
	echo_error "${abspath}/${FETCHEDDIR}/build does not exist!"
	exit 1
fi

DESTDIR=${abspath}/${MNT}/usr/local/ilink/bin

mkdir -p ${DESTDIR}
cp -pPf ${PROJECT_ABSPATH}/build/* ${DESTDIR}/ || exit 1
