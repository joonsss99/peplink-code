#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

#conf_args='--disable-nls'

#cd $FETCHEDDIR
#if [ ! -e $FETCHEDDIR/Makefile ] ; then
#	./configure --host=$HOST_PREFIX --prefix=/usr $conf_args || exit $?
#fi

make -C $FETCHEDDIR CC=$HOST_PREFIX-gcc CFLAGS=-O2 peplink || exit $?
#make DESTDIR=$STAGING install || exit $?

