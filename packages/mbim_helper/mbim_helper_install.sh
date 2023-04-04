#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

PROJECT_ABSPATH="${abspath}/${FETCHEDDIR}"

if [ ! -d $PROJECT_ABSPATH/build ]; then
	echo_error "${PROJECT_ABSPATH}/build does not exist!"
	exit 1
fi

DESTDIR=${abspath}/${MNT}/usr/local/ilink/bin

mkdir -p ${DESTDIR}
cp -pPf $PROJECT_ABSPATH/build/* ${DESTDIR}/ || exit 1
