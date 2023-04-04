#!/bin/sh

PACKAGE=$1

abspath=`pwd`
FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions
. ${PACKAGESDIR}/common/common_pkg_config_vars.sh

#
# nettle
#
# See INSTALL.md of gnutls
#

cd ${FETCHEDDIR}/devel/nettle || exit $?

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
		--libdir=/usr/lib \
		--host=${HOST_PREFIX} \
		--disable-static \
		--disable-openssl \
		--disable-documentation \
		|| exit $?
fi

make ${MAKE_OPTS} || exit $?
make ${MAKE_OPTS} DESTDIR=${STAGING} install || exit $?

cd - || exit $?

#
# gnutls
#

cd ${FETCHEDDIR} || exit $?

if [ ! -x configure ]; then
	./bootstrap --no-bootstrap-sync --skip-po \
		--no-git --gnulib-srcdir=gnulib || exit $?
fi

if [ ! -f Makefile ]; then
	CFLAGS="-I${STAGING}/usr/include" \
	CPPFLAGS="-I${STAGING}/usr/include" \
	LDFLAGS="-L${STAGING}/usr/lib" \
	HOGWEED_LIBS="-L${STAGING}/usr/lib -lhogweed -lgmp" \
	./configure \
		--srcdir=. \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--prefix=/usr \
		--host=${HOST_PREFIX} \
		--disable-bash-tests \
		--disable-doc \
		--disable-tools \
		--disable-tests \
		--disable-nls \
		--enable-guile=no \
		--disable-rpath \
		--disable-full-test-suite \
		--without-p11-kit \
		|| exit $?
fi

make ${MAKE_OPTS} || exit $?
make ${MAKE_OPTS} DESTDIR=${STAGING} install || exit $?

common_fix_la_libdir \
	"${STAGING}/usr/lib/libgnutls.la" \
	"${STAGING}/usr/lib/libgnutlsxx.la" \
	|| exit $?
