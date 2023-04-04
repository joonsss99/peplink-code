#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

[ "${HAS_CONTENTHUB_PACKAGES}" = "y" ] \
	&& _DESTDIR=${abspath}/tmp/contenthub_packages/libraries/host-essential \
	|| _DESTDIR=${abspath}/${MNT}
mkdir -p ${_DESTDIR}/usr/lib/tcl8.6 || exit $?
cp -df ${FETCHEDDIR}/unix/libtcl*.so* ${_DESTDIR}/usr/lib/ || exit $?
cp -df ${FETCHEDDIR}/library/init.tcl ${_DESTDIR}/usr/lib/tcl8.6/ || exit $?
${HOST_PREFIX}-strip ${_DESTDIR}/usr/lib/libtcl*.so* || exit $?
