#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

. ./make.conf

abspath=`pwd`

cd ${FETCHEDDIR} || exit $?
if [ ! -f configure ]; then
	./autogen.sh || exit $?
fi

if [ ! -f Makefile ]; then
	./configure --host=$HOST_PREFIX --prefix=/usr \
		--disable-shared --disable-doc --disable-tests \
		--disable-languages --disable-nls --with-pic || exit $?
fi

make $MAKE_OPTS || exit $?
make install DESTDIR=$STAGING || exit $?
# prevent .la file mess around libtool with /usr/lib library path
rm -f $STAGING/usr/lib/libgpg-error.la
