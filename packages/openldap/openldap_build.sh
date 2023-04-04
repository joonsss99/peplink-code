#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR || exit $?

if require_configure ; then
	# ac_cv_func_memcmp_working work around AC_FUNC_MEMCMP always fail
	# on cross compiling configure
	CC=$HOST_PREFIX-gcc \
	ac_cv_func_memcmp_working=yes \
	./configure \
		--build=`gcc -dumpmachine` \
		--host=$HOST_PREFIX \
		--enable-bdb=no \
		--enable-hdb=no \
		--enable-ndb=no \
		--with-yielding_select=no \
		--with-tls=no \
		--prefix=/usr || exit $?

	sed 's/SUBDIRS= include libraries.*/SUBDIRS= include libraries/g' Makefile > Makefile.new || exit $?
	[ -f Makefile.new ] && mv Makefile.new Makefile
fi

make depend CC=$HOST_PREFIX-gcc AR=$HOST_PREFIX-ar || exit $?
make CC=$HOST_PREFIX-gcc AR=$HOST_PREFIX-ar $MAKE_OPTS || exit $?
make install DESTDIR=$STAGING || exit $?

# don't let libtool mess with the library path (/usr/lib/... would be used with incorrect .la)
rm -f $STAGING/usr/lib/liblber*.la $STAGING/usr/lib/libldap*.la
