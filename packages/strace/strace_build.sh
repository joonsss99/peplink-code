#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd $FETCHEDDIR || exit 1
# strace requires git tags in the tree to build version string
git fetch --tags || exit $?
if [ ! -f configure ] ; then
	./bootstrap || exit $?
fi
if [ ! -f Makefile ] ; then
	EXT_OPTS=
	[ "${PL_BUILD_ARCH}" = "arm64" ] && EXT_OPTS="--enable-mpers=no"
	./configure --host=$HOST_PREFIX --prefix=/usr ${EXT_OPTS} || exit $?
fi

make $MAKE_OPTS || exit $?
