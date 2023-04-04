#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

install -p --strip --strip-program="${HOST_PREFIX}-strip" \
	${FETCHEDDIR}/dmidecode ${abspath}/${MNT}/usr/sbin || exit $?
