#!/bin/sh

PACKAGE=$1

FETCHEDDIR=$FETCHDIR/$PACKAGE

[ "$TARGET_SERIES" != "fhvm" ] && exit

. ./make.conf

abspath=`pwd`

fmk="-f $PROJECT_MAKE/Makefile"

make $fmk -C $FETCHEDDIR empty_defconfig 2> /dev/null
make $fmk -C $FETCHEDDIR ${PL_BUILD_ARCH}_defconfig 2> /dev/null
make $fmk -C $FETCHEDDIR ${HOST_MODE}_defconfig 2> /dev/null

flags="CONFIG_X86_GENERIC_SETHWINFO=y"

make $fmk -C $FETCHEDDIR $flags sethwinfo || exit $?
make $fmk -C $FETCHEDDIR $flags DESTDIR=$abspath/tools/host PREFIX=/ bin-y=sethwinfo install-exec || exit $?

make $fmk -C $FETCHEDDIR $flags clean
