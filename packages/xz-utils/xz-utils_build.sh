#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

cd ${FETCHEDDIR}
if [ ! -f "configure" ]; then
	./autogen.sh || exit $?
fi
if [ ! -f "Makefile" ]; then
	./configure --prefix=/usr/local || exit $?
fi
cd ${abspath}

make -C ${FETCHEDDIR} ${MAKE_OPTS} || exit $?
make -C ${FETCHEDDIR} install DESTDIR=${abspath}/tmp || exit $?
