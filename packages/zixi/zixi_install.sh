#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

fmk="-f $PROJECT_MAKE/Makefile"

make $fmk -C $FETCHEDDIR/src \
	DOTCONFIG_DIR=.. \
	PREFIX=/usr/local/ilink/ \
	CROSS_COMPILE=$HOST_PREFIX- DESTDIR=${abspath}/${MNT}/ \
	install || exit $?

make $fmk -C $FETCHEDDIR/lib \
	DOTCONFIG_DIR=.. \
	PREFIX=/usr/ \
	CROSS_COMPILE=$HOST_PREFIX- DESTDIR=${abspath}/${MNT}/ \
	install-lib || exit $?
