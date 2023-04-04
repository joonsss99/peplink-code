#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR || exit $?

if [ ! -f configure ] ; then
	autoreconf --verbose --install --force -I gl/m4 --no-recursive || exit $?
fi

if [ ! -f Makefile ] ; then
	if [ "$PL_BUILD_ARCH" = "ar7100" -o "$PL_BUILD_ARCH" = "powerpc" ]; then
		gl_cv_func_wcwidth_works=yes ./configure --host=${HOST_PREFIX} --disable-nls || exit $?
	else
		./configure --host=${HOST_PREFIX} --disable-nls || exit $?
	fi
fi

make -C gl $MAKE_OPTS || exit $?
make -C lib $MAKE_OPTS || exit $?
make -C xargs $MAKE_OPTS || exit $?
