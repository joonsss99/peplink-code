#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

make -C $FETCHEDDIR empty_defconfig || exit $?
make -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- all $MAKE_OPTS || exit $?
make -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$STAGING install-dev || exit $?
