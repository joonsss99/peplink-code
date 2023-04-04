#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

[ "${HAS_CONTENTHUB_PACKAGES}" = "y" ] \
	&& _DESTDIR=${abspath}/tmp/contenthub_packages/libraries/host-essential \
	|| _DESTDIR=${abspath}/${MNT}
install -D -p -t ${_DESTDIR}/bin --strip --strip-program=${HOST_PREFIX}-strip \
	${FETCHEDDIR}/sapi/cgi/php-cgi || exit $?
