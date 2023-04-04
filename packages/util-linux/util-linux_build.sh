#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

disable_switch="--disable-login \
	--disable-mount \
	--disable-libuuid \
	--disable-libmount \
	--disable-fsck \
	--disable-sulogin \
	--disable-su \
	--disable-mount"

cd $FETCHEDDIR || exit $?
if [ ! -f configure ]; then
	./autogen.sh || exit $?
fi

if [ ! -f Makefile ] ;  then
	./configure --host=$HOST_PREFIX --without-ncurses --without-selinux --without-audit $disable_switch || exit $?
fi

UTILS="setsid hwclock flock taskset"
if [ "${HAS_STORAGE_MGMT_TOOLS}" = "y" ]; then
UTILS+=" sfdisk fstrim"
fi
make $UTILS $MAKE_OPTS || exit $?
