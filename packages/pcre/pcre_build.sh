#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

STRIP=$HOST_PREFIX-strip

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR
if [ ! -f configure ] ; then
	mkdir -p m4
	aclocal -I . || exit $?
	autoreconf -f -i -Wall,no-obsolete || exit $?
fi

if [ ! -f Makefile ] ; then
	./configure --prefix=$STAGING/usr --host=$HOST_PREFIX --build=`gcc -dumpmachine` --disable-static --disable-cpp || exit $?
fi

make $MAKE_OPTS || exit $?

#
# do not use make install for pcre as libtool will try to use native build tool to mess with crosscompiled binary
#
install -d $STAGING/usr/bin || exit $?
install -d $STAGING/usr/lib || exit $?
install -d $STAGING/usr/lib/pkgconfig || exit $?
install -d $STAGING/usr/include || exit $?
cp -df .libs/pcretest .libs/pcregrep pcre-config $STAGING/usr/bin || exit $?
cp -df libpcre.pc libpcreposix.pc libpcrecpp.pc $STAGING/usr/lib/pkgconfig || exit $?
cp -df .libs/libpcre*so* $STAGING/usr/lib || exit $?
cp -df pcre.h pcre_scanner.h pcre_stringpiece.h pcrecpp.h pcrecpparg.h pcreposix.h $STAGING/usr/include || exit $?

