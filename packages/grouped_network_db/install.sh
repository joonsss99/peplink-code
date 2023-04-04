#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

fmk="-f $PROJECT_MAKE/Makefile"

mkdir -p $abspath/$MNT/var/run/ilink/saas

make $fmk -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$abspath/$MNT PREFIX=/usr/local/ilink install-exec || exit $?
make $fmk -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$abspath/$MNT PREFIX=/ install-extra || exit $?
make $fmk -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$abspath/$MNT PREFIX=/ install-symlink || exit $?
