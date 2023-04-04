#!/bin/sh

PACKAGE=$1

ABSPATH=`pwd`
FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd ${FETCHEDDIR}/smartmontools

if [ ! -f configure ]; then
	aclocal -I . || exit $?
	mkdir -p m4
	autoreconf -f -i -Wall,no-obsolete || exit $?
fi

if [ ! -f Makefile ]; then
	./configure CC=${HOST_PREFIX}-gcc CXX=${HOST_PREFIX}-g++ --host=${HOST_PREFIX}
fi

make ${MAKE_OPTS} || exit $?
