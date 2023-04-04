#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

DESTDIR=${abspath}/$MNT/usr/bin

mkdir -p ${DESTDIR}
for b in bird birdcl ; do
	cp -Pp $FETCHEDDIR/${b} ${DESTDIR}/ || exit $?
	$HOST_PREFIX-strip ${DESTDIR}/${b}
done
