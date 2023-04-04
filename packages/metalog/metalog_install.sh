#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

binfile=metalog

DESTDIR=${abspath}/${MNT}/usr/bin

if [ ! -f ${FETCHEDDIR}/src/${binfile} ] ; then
	echo "missing binary in ${FETCHEDDIR}/src/${binfile}"
	exit 1
fi

mkdir -p ${DESTDIR}
cp -Rpf ${FETCHEDDIR}/src/${binfile} ${DESTDIR}/ || exit $?
${HOST_PREFIX}-strip ${DESTDIR}/${binfile} || exit $?
