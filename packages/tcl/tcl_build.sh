#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd ${FETCHEDDIR}/unix

if [ ! -f Makefile ]; then
	ac_cv_func_strtod=yes tcl_cv_strtod_buggy=1 \
		./configure --host=${HOST_PREFIX} || exit $?
fi

make ${MAKE_OPTS} CC=$HOST_PREFIX-gcc || exit $?

install -d ${STAGING}/usr/lib || exit $?
install -d ${STAGING}/usr/include || exit $?
cp -df ../generic/tcl*.h ${STAGING}/usr/include || exit $?
cp -df libtcl*.so* ${STAGING}/usr/lib || exit $?
