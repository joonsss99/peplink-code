#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
cd $FETCHEDDIR || exit $?

# ubifs utilities to install
UBI_TOOLS="ubiattach ubidetach ubimkvol ubirmvol ubiupdatevol ubinfo ubiformat"
BIN_DIR=/usr/sbin

TMP_INSTALL_DIR=`mktemp -d`
if [ -z $TMP_INSTALL_DIR ]; then
	TMP_INSTALL_DIR=/tmp/tmp.$$
	mkdir -p $TMP_INSTALL_DIR || exit $?
fi

DESTDIR=$TMP_INSTALL_DIR make install-exec || exit $?

cd $TMP_INSTALL_DIR/$BIN_DIR
$HOST_PREFIX-strip $UBI_TOOLS || exit $?

# Enable this in case you want utilities to be present in FW
#mkdir -p $abspath/$MNT/$BIN_DIR || exit $?
#cp $UBI_TOOLS $abspath/$MNT/$BIN_DIR || exit $?

# Install ubifs utilities to firmware upgrader rootfs
mkdir -p $abspath/$UPGRADER_ROOT_DIR/$BIN_DIR || exit $?
cp $UBI_TOOLS $abspath/$UPGRADER_ROOT_DIR/$BIN_DIR || exit $?

rm -fr $TMP_INSTALL_DIR
