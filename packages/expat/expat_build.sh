#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR/expat

if [ ! -f configure ]; then
	./buildconf.sh || exit $?
fi

if [ ! -f Makefile ]; then
	autoreconf -fvi
	automake -acf
	./configure --prefix=/usr \
		--host=$HOST_PREFIX --without-docbook || exit $?
fi

make $MAKE_OPTS || exit $?
make $MAKE_OPTS DESTDIR=$STAGING install || exit $?
rm -f ${STAGING}/usr/lib/libexpat*.la
