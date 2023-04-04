#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd ${FETCHEDDIR}

mkdir -p $abspath/$MNT/usr/sbin
mkdir -p $abspath/$MNT/usr/bin

if [ "$BLD_CONFIG_KERNEL_V2_6_28" = "y" ] ;then
	cp objdir/agent/snmpd $abspath/$MNT/usr/sbin/ || exit $?
else
	mkdir -p $abspath/$MNT/usr/lib
	cp objdir/agent/.libs/snmpd $abspath/$MNT/usr/sbin/ || exit $?
	cp -dpf objdir/agent/helpers/.libs/libnetsnmp*.so* $abspath/$MNT/usr/lib/ || exit $?
	cp -dpf objdir/agent/.libs/libnetsnmp*.so* $abspath/$MNT/usr/lib/ || exit $?
	cp -dpf objdir/snmplib/.libs/libnetsnmp*.so* $abspath/$MNT/usr/lib/ || exit $?
	$HOST_PREFIX-strip $abspath/$MNT/usr/lib/libnetsnmp*
fi

cp src/snmpconf $abspath/$MNT/usr/bin/ || exit $?

$HOST_PREFIX-strip --remove-section=.note --remove-section=.comment $abspath/$MNT/usr/bin/snmpconf
$HOST_PREFIX-strip --remove-section=.note --remove-section=.comment $abspath/$MNT/usr/sbin/snmpd

