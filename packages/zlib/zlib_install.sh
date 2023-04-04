#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

[ "${HAS_CONTENTHUB_PACKAGES}" = "y" ] \
	&& _DESTDIR=${abspath}/tmp/contenthub_packages/libraries/host-essential \
	|| _DESTDIR=${abspath}/${MNT}
INSTALL_DIR=${_DESTDIR}/usr/lib
mkdir -p ${INSTALL_DIR} || exit $?
cd $FETCHEDDIR/_install/usr/lib \
	&& tar -cf - libz.so* | tar -C ${INSTALL_DIR} -xf - || exit $?
$HOST_PREFIX-strip ${INSTALL_DIR}/libz.so

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	# kdump 2.0.20 needs it
	[ ! -d $abspath/$KDUMP_ROOT_DIR/lib ] && mkdir -p $abspath/$KDUMP_ROOT_DIR/lib
	tar -cf - libz.so* | tar -C $abspath/$KDUMP_ROOT_DIR/lib -xf - || exit $?
	$HOST_PREFIX-strip $abspath/$KDUMP_ROOT_DIR/lib/libz.so
fi
