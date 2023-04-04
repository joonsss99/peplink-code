#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd ${FETCHEDDIR}

if [ ! -f configure ] ; then
	autoreconf -ivsf || exit $?
fi


if [ ! -f Makefile ]; then
	# force $cross_compiling to yes in configure script by using different --build and --host prefix
	./configure --build=`gcc -dumpmachine` --host=$HOST_PREFIX \
		--prefix=/usr \
		--sysconfdir=/etc/ssh \
		--with-zlib=$STAGING/usr \
		--with-default-path="/tmp/bin:/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/ilink/bin" \
		|| exit $?
fi

make ssh $MAKE_OPTS || exit $?
make sshd $MAKE_OPTS || exit $?
make scp $MAKE_OPTS || exit $?
