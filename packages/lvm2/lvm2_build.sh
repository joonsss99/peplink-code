#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions
. ${PACKAGESDIR}/common/common_pkg_config_vars.sh

abspath=`pwd`


cd ${FETCHEDDIR} || exit $?

if [ ! -f Makefile ]; then
	ac_cv_func_malloc_0_nonnull=yes \
	ac_cv_func_realloc_0_nonnull=yes \
	./configure --prefix=/usr --host=$HOST_PREFIX --disable-valgrind || exit $?
fi

if [ "${BLD_CONFIG_MEDIAFAST_BUILT_IN}" = "y" ]; then
	make tools $MAKE_OPTS || exit $?
else
	make device-mapper $MAKE_OPTS || exit $?
fi
make -C libdm install DESTDIR=${STAGING} \
		STRIP="--strip --strip-program=${HOST_PREFIX}-strip" || exit $?
