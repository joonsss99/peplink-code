#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

[ ! -f ${FETCHEDDIR}/build/modprobe ] && exit 1

bins="modprobe insmod rmmod lsmod"

DESTDIR=${abspath}/${MNT}/sbin

mkdir -p ${DESTDIR}

for b in $bins; do
	cp -pf ${FETCHEDDIR}/build/${b} ${DESTDIR}/
	$HOST_PREFIX-strip ${DESTDIR}/${b}
done

