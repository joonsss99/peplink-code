#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

fmk="-f $PROJECT_MAKE/Makefile"

make $fmk -C $FETCHEDDIR empty_defconfig
make $fmk -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX-
