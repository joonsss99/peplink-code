#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR
mkdir -p $abspath/$MNT || exit $?
tar xzf ramdisk.tar.gz -C $abspath/$MNT || exit $?

fakeroot_session_start

case $PL_BUILD_ARCH in
ixp|ar7100)
	rm -rf $abspath/$MNT/dev/*
	PATH="$HOST_TOOL_DIR/bin:$PATH" $FAKEROOT_CMD tar xzf ramdisk_device.tar.gz -C $abspath/$MNT || exit $?
	;;
*)
	;;
esac

exit 0

