#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

[ "${HAS_CONTENTHUB_PACKAGES}" = "y" ] \
	&& _DESTDIR=${abspath}/tmp/contenthub_packages/libraries/host-essential \
		WGET_NAME="wget" \
	|| _DESTDIR=${abspath}/${MNT} \
		WGET_NAME="gnu_wget"
install -D -p --strip --strip-program=${HOST_PREFIX}-strip \
	${FETCHEDDIR}/src/wget "${_DESTDIR}/usr/bin/${WGET_NAME}" || exit $?
