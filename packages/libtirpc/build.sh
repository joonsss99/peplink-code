#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR || exit $?

if [ ! -f configure ]; then
        ./bootstrap
fi

if [ ! -f Makefile ]; then
        ./configure --host=$HOST_PREFIX --disable-shared --disable-gssapi --disable-ipv6 --with-pic || exit $?
fi

make $MAKE_OPTS || exit $?
make install DESTDIR=$STAGING || exit $?

