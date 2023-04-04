#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

fmk="-f $PROJECT_MAKE/Makefile"

make $fmk -C $FETCHEDDIR empty_defconfig || exit $?

make $fmk -C $FETCHEDDIR $MAKE_OPTS || exit $?
make $fmk -C $FETCHEDDIR $MAKE_OPTS DESTDIR="./" PREFIX="" install || exit $?
