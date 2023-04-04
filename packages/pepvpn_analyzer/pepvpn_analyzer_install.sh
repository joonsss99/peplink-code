#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

make -f $PROJECT_MAKE/Makefile -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- install DESTDIR=$abspath/$MNT PREFIX=/usr/local/ilink || exit $?
