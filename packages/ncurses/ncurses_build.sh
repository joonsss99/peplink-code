#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

conf_args='--disable-database --disable-big-core --disable-home-terminfo --without-cxx-binding --without-ada --without-develop'

cd $FETCHEDDIR || exit $?
if [ ! -e Makefile ] ; then
	CFLAGS="-fPIC" \
	./configure --host=$HOST_PREFIX $conf_args --with-fallbacks="linux vt100 vt102 vt220 ansi xterm xterm-color dumb" || exit $?
fi

make $MAKE_OPTS || exit $?
make DESTDIR=$STAGING install || exit $?
