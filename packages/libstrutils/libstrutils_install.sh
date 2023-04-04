#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

[ "${HAS_CONTENTHUB_PACKAGES}" = "y" ] \
	&& DESTDIR_LIST=${abspath}/tmp/contenthub_packages/libraries/host-essential \
	|| DESTDIR_LIST="${abspath}/${MNT} ${abspath}/${UPGRADER_ROOT_DIR}"
for _DESTDIR in ${DESTDIR_LIST}; do
	make -f $PROJECT_MAKE/Makefile -C $FETCHEDDIR \
		CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$_DESTDIR \
		install || exit $?
done
