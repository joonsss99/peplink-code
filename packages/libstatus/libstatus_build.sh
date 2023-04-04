#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

fmk="-f $PROJECT_MAKE/Makefile"
make $fmk -C $FETCHEDDIR empty_defconfig

make $fmk -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- all $MAKE_OPTS || exit $?
make $fmk -C $FETCHEDDIR cROSS_COMPILE=$HOST_PREFIX- DESTDIR=$STAGING install-dev || exit $?
