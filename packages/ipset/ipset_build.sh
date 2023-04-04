#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions
. ${PACKAGESDIR}/common/common_pkg_config_vars.sh

abspath=`pwd`

cd $FETCHEDDIR || exit $?

if [ ! -e $abspath/$FETCHEDDIR/configure ]; then
	./autogen.sh || exit $?
fi

if [ ! -e $abspath/$FETCHEDDIR/Makefile ]; then
	CFLAGS=-I$STAGING/usr/include \
	LDFLAGS=-L$STAGING/usr/lib \
	libmnl_CFLAGS=-I$STAGING/usr/include \
	libmnl_LIBS="-L$STAGING/usr/lib -lmnl" \
	./configure --prefix=/usr \
		--host=$HOST_PREFIX \
		--with-ksource=${KERNEL_SRC} \
		--with-kbuild=${KERNEL_OBJ} \
		--libexecdir=/usr/lib \
		--includedir=/usr/include \
		--with-kernel=$KERNEL_HEADERS \
		|| exit $?
fi

make $MAKE_OPTS || exit $?
make DESTDIR=$abspath/$FETCHEDDIR/staging install || exit $?
