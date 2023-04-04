#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions
. ${PACKAGESDIR}/common/common_pkg_config_vars.sh

. ./make.conf

abspath=`pwd`

LIBGCRYPTPATH=${abspath}/${FETCHDIR}/libgcrypt/libgcrypt-1.4.5

cd ${FETCHEDDIR} || exit $?

if [ ! -f configure ] ; then
	AL_OPTS="-I $STAGING/usr/share/aclocal" ./autogen.sh || exit $?
fi

if [ ! -f Makefile ]; then
	CFLAGS=-I$STAGING/usr/include \
	LDFLAGS=-L$STAGING/usr/lib \
	./configure --host=$HOST_PREFIX \
	--disable-nls \
	--disable-kernel_crypto \
	--disable-shared \
	--disable-selinux \
	--disable-internal-argon2 \
	--with-libgcrypt-prefix=$STAGING/usr \
	--prefix=/usr || exit $?
fi

make $MAKE_OPTS || exit $?
