#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ "$BLD_CONFIG_IPV6" = "y" ]; then
	cp -pPfr ${FETCHEDDIR}/build/* $abspath/$MNT/ || exit $?
	ln -sf dhclient $abspath/$MNT/sbin/dhclient6
	mkdir -p $abspath/$MNT/var/run/ilink/ipv6

	cd $abspath
fi
