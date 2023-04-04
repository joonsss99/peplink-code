#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

fmk="-f $PROJECT_MAKE/Makefile"

make $fmk -C $FETCHEDDIR empty_defconfig || exit $?
make $fmk -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- || exit $?
