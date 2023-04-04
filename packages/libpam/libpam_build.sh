#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

cd ${FETCHEDDIR}

if [ ! -f configure ] ; then
	./autogen.sh
fi

if [ ! -f Makefile ]; then
	CFLAGS="-I$STAGING/usr/include" \
	LDFLAGS="-L$STAGING/usr/lib" \
	LIBS="-L${STAGING}/usr/lib"
	./configure --host=$HOST_PREFIX \
	--prefix=/usr \
	--disable-regenerate-docu \
	--disable-nis \
	|| exit $?
fi

make $MAKE_OPTS || exit $?

make install DESTDIR=$STAGING || exit $?
