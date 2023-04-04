#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
cd ${FETCHEDDIR}

if [ ! -f Makefile.opts ]; then
	./configure --host=$HOST_PREFIX --prefix=/usr || exit $?
fi

make CC=${HOST_PREFIX}-gcc LD=${HOST_PREFIX}-ld AR=${HOST_PREFIX}-ar $MAKE_OPTS || exit $?

make install DESTDIR=${STAGING}/ || exit $?
rm -f ${STAGING}/usr/lib/libnl.so*

cd ${abspath}

