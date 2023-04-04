#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR

if [ ! -f configure ]; then
	./autogen.sh || exit $?
fi

if [ ! -f Makefile ]; then
	LIBS="-L$STAGING/usr/lib" \
	CFLAGS="-I$STAGING/usr/include" \
	NCURSES_CFLAGS="-I$STAGING/usr/include" \
	NCURSES_LIBS="-L$STAGING/usr/lib -lcurses" \
	ac_cv_func_malloc_0_nonnull=yes \
	ac_cv_func_realloc_0_nonnull=yes \
	./configure --host=$HOST_PREFIX --prefix=/ --with-sysroot=$STAGING --disable-modern-top || exit $?
fi

make $MAKE_OPTS || exit $?
make DESTDIR=$abspath/$FETCHEDDIR/_install install || exit $?
