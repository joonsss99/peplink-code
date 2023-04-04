#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

make -f $PROJECT_MAKE/Makefile -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$abspath/$RAMFS_ROOT install || exit $?
