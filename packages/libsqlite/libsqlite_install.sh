#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd "${FETCHEDDIR}" || exit $?

[ "${HAS_CONTENTHUB_PACKAGES}" = "y" ] \
	&& _DESTDIR=${abspath}/tmp/contenthub_packages/libraries/host-essential \
	|| _DESTDIR=${abspath}/${MNT}

make CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$_DESTDIR lib_install || exit $?
rm -f $_DESTDIR/usr/lib/libsqlite*.la || exit $?
$HOST_PREFIX-strip $_DESTDIR/usr/lib/libsqlite3.so* || exit $?

install -s --strip-program=$HOST_PREFIX-strip \
	-D -t $_DESTDIR/usr/bin \
	./sqlite3 || exit $?
ln -sf sqlite3 $_DESTDIR/usr/bin/sqlite || exit $?
