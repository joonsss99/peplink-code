#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

cd $FETCHEDDIR || exit $?
if [ ! -f configure ] ; then
	autoconf autoconf/configure.in > configure
	chmod 755 configure
	:> autoconf/make/depend.mk~
	:> autoconf/make/filelist.mk~
	:> autoconf/make/modules.mk~
	rm -rf autom4te.cache
fi
if [ ! -f Makefile ] ; then
	./configure --host=$HOST_PREFIX --prefix=/usr \
		--disable-nls \
		--disable-splice \
		--disable-ipc || exit $?
	make make
	make dep
fi

make $MAKE_OPTS LD=${HOST_PREFIX}-ld || exit $?
