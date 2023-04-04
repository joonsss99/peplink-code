#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cp -pf $FETCHEDDIR/cryptsetup ${abspath}/${MNT}/bin || exit $?
$HOST_PREFIX-strip $abspath/$MNT/bin/cryptsetup || exit $?

cp -pf $FETCHEDDIR/cryptsetup $abspath/$UPGRADER_ROOT_DIR/bin/ || exit $?
$HOST_PREFIX-strip $abspath/$UPGRADER_ROOT_DIR/bin/cryptsetup || exit $?

if [ "$FW_CONFIG_KDUMP" = "y" -a "$KDUMP_DM_CRYPT_PARTITION" = "y" ]; then
	cp -pf $FETCHEDDIR/cryptsetup $abspath/$KDUMP_ROOT_DIR/bin/ || exit $?
	$HOST_PREFIX-strip $abspath/$KDUMP_ROOT_DIR/bin/cryptsetup || exit $?
fi
