#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

case "$PL_BUILD_ARCH" in
x86_64)
	LANDEV="eth0"
	;;
ar7100)
	LANDEV="eth1"
	;;
powerpc)
	LANDEV="eth0"
	;;
arm|arm64|ramips)
	LANDEV="eth0"
	;;
esac

if [ "$BLD_CONFIG_ENCRYPT_FIRMWARE" = "y" ] ; then
	ENCRYPT_FW="-DENCRYPT_FW=1"
else
	ENCRYPT_FW=""
fi

make -f $PROJECT_MAKE/Makefile -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- empty_defconfig
make -f $PROJECT_MAKE/Makefile -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS CFLAGS="-Wall -g -MMD $ENCRYPT_FW -DLANDEV=\\\"$LANDEV\\\"" fwupgrade
