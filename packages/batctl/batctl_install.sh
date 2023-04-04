#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

_DESTDIR=${abspath}/${MNT}

install -D -p --strip --strip-program=${HOST_PREFIX}-strip \
	${FETCHEDDIR}/${PACKAGE} "${_DESTDIR}/usr/sbin/${PACKAGE}" || exit $?
