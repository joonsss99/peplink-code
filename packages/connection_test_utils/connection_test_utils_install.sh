#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

mkdir -p $abspath/$MNT/var/run/ilink/ic_conn_test/
make -f $PROJECT_MAKE/Makefile -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- \
	install DESTDIR=$abspath/$MNT TARGET=$BUILD_TARGET \
	|| exit $?
