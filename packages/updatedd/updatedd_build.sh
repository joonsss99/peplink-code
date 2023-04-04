#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

cd ${FETCHEDDIR}/updatedd-2.6 || exit $?

if require_configure ; then
	# replacing existing configure, also update config.guess and config.sub
	# to modern version and align with build system
	autoreconf -ivf || exit $?
	./configure --prefix=/ --host=${HOST_PREFIX} || exit $?
fi
make exec_libdir=/lib $MAKE_OPTS || exit $?

$HOST_PREFIX-strip --strip-unneeded \
	src/plugins/.libs/*.so || exit $?
$HOST_PREFIX-strip --remove-section=.note --remove-section=.comment \
	src/updatedd || exit $?
