#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

tools="usr/lib/libpopt.so usr/lib/libpopt.so.0 usr/lib/libpopt.so.0.0.0"

for t in $tools ; do
	mkdir -p `dirname $abspath/$MNT/$t`
	cp -Pp $STAGING/$t $abspath/$MNT/$t || exit $?
	if [ ! -L "$STAGING/$t" ]; then
		$HOST_PREFIX-strip $abspath/$MNT/$t
	fi
	cp -Pp $abspath/$MNT/$t $abspath/$UPGRADER_ROOT_DIR/$t || exit $?

	if [ "$FW_CONFIG_KDUMP" = "y" -a "$KDUMP_DM_CRYPT_PARTITION" = "y" ]; then
		mkdir -p `dirname $abspath/$KDUMP_ROOT_DIR/$t`
		cp -Pp $abspath/$MNT/$t $abspath/$KDUMP_ROOT_DIR/$t || exit $?
	fi
done
