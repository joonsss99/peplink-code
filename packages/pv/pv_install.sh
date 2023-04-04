#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

binfile=pv

DESTDIR=${abspath}/${MNT}/usr/bin

if [ ! -f ${FETCHEDDIR}/${binfile} ] ; then
	echo "missing binary in ${FETCHEDDIR}/${binfile}"
	exit 1
fi

mkdir -p ${DESTDIR}
cp -Rpf ${FETCHEDDIR}/${binfile} ${DESTDIR}/ || exit $?
${HOST_PREFIX}-strip ${DESTDIR}/${binfile} || exit $?
