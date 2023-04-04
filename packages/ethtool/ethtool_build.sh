#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

cd $FETCHEDDIR || exit $?

if [ ! -f configure ]; then
	./autogen.sh || exit $?
fi

if [ ! -f Makefile ]; then
	./configure CFLAGS="-I${STAGING}/usr/include" \
			--host=$HOST_PREFIX --enable-netlink=no || exit $?
fi

make ethtool $MAKE_OPTS || exit $?
