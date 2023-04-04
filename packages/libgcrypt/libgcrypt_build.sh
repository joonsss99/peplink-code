#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`


cd ${FETCHEDDIR} || exit $?
if [ ! -f configure ] ; then
	./autogen.sh || exit $?
fi
if [ ! -f Makefile ]; then
	LDFLAGS=-L$STAGING/usr/lib \
	CFLAGS="-I$STAGING/usr/include" \
	./configure --host=$HOST_PREFIX --prefix=/usr \
	--disable-shared \
	--with-gpg-error-prefix=$STAGING/usr \
	--disable-doc \
	--with-sysroot=$STAGING \
	--with-pic || exit $?
fi

make $MAKE_OPTS || exit $?
make install DESTDIR=${STAGING} || exit $?
# the .la file is messing up libtool with /usr/lib
rm -f $STAGING/usr/lib/libgcrypt.la
