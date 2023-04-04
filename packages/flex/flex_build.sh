#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd ${FETCHEDDIR} || exit $?

if [ ! -f configure ] ; then
	./autogen.sh || exit $?
fi

if [ ! -f Makefile ] ; then
	# ac variables needed to fix host "stageflex" build on
	# cross-compile build. otherwise we need to fix configure.ac
	ac_cv_func_realloc_0_nonnull="yes" \
	ac_cv_func_malloc_0_nonnull="yes" \
	ac_cv_func_reallocarray=no \
	./configure \
		--host=$HOST_PREFIX \
		--prefix=/usr \
		--disable-shared \
		|| exit $?
fi

make $MAKE_OPTS || exit $?
make install-exec DESTDIR=$STAGING || exit $?
