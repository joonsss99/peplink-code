#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

fmk="-f $PROJECT_MAKE/Makefile"

# this work around the Makefile requiring .config. If we ever need configuration
# (thru defconfig), remember to remove this line
touch $FETCHEDDIR/.config

make $fmk -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- all $MAKE_OPTS || exit $?
