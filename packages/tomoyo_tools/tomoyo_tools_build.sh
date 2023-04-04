#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

cd ${FETCHEDDIR}

make ${MAKE_OPTS} CC=${HOST_PREFIX}-gcc INSTALLDIR=${abspath}/${MNT}/ \
	USRLIBDIR=/usr/lib CFLAGS="-I${STAGING}/usr/include" LDFLAGS="-L${STAGING}/usr/lib" || exit $?
