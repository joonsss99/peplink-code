#!/bin/sh

set -e

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

make -f $PROJECT_MAKE/Makefile -C $FETCHEDDIR \
	CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$STAGING install-headers
