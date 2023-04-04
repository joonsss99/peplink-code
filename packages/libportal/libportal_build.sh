#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

CC=$HOST_PREFIX-gcc
AR=$HOST_PREFIX-ar
STRIP=$HOST_PREFIX-strip

case $BUILD_TARGET in
apone|aponeac|aponeax)
	AP_PORTAL="AP_PORTAL=1"
	;;
esac

abspath=`pwd`

CC=${CC} AR=${AR} STRIP=${STRIP} make -C ${FETCHEDDIR} $makeflag BALANCE=1 IPTABLES_ENHANCE=1 PORTAL_CONF_MOD=1 RADIUS=1 LDAP=1 COOVA=1 BANDWIDTH_CTL=1 $AP_PORTAL all || exit $?
