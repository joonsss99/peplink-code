#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

# some configure script doesn't like uclibc in hostprefix
hostprefix=`echo $HOST_PREFIX | sed 's/-uclibc//'`

cd $FETCHEDDIR || exit $?
if [ ! -f Makefile ] ; then
	# replacing existing configure, also update config.guess and config.sub
	# to modern version and align with build system
	autoreconf -ivf || exit $?
	./configure --host=$hostprefix --prefix=/usr || exit $?
fi

make $MAKE_OPTS || exit $?
make install DESTDIR=$STAGING || exit $?
make install-includeHEADERS DESTDIR=$STAGING || exit $?

# fix for libtool to use the wrong directory "/usr/lib" when linking against it (only when libtool is doing the linking)
sed -i -e "s;^libdir='/;libdir='$STAGING/;" $STAGING/usr/lib/libpopt.la

