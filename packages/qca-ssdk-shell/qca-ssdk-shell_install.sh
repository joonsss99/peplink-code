#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

install -p -m 755 $FETCHEDDIR/build/bin/ssdk_sh \
	$abspath/$MNT/usr/bin || exit $?
