#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

cd ${FETCHEDDIR} || exit $?

if [ ! -x configure ]; then
	./.bootstrap || exit $?
fi

if [ ! -f Makefile ]; then
	CFLAGS="-I${STAGING}/usr/include" \
	CPPFLAGS="-I${STAGING}/usr/include" \
	LDFLAGS="-L${STAGING}/usr/lib" \
	./configure \
		--srcdir=. \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--prefix=/usr \
		--host=${HOST_PREFIX} \
		|| exit $?
fi

make ${MAKE_OPTS} || exit $?
make ${MAKE_OPTS} DESTDIR=${STAGING} install || exit $?

common_fix_la_libdir "${STAGING}/usr/lib/libgmp.la" || exit $?
