#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}
SERVERDIR=${FETCHEDDIR}/freeradius-server

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR || exit $?

if [ ! -f Make.inc ] ; then
	CPPFLAGS=-I$STAGING/usr/include \
	CFLAGS=-I$STAGING/usr/include \
	LDFLAGS=-L$STAGING/usr/lib \
	LIBS=-llber \
	./configure --build=`gcc -dumpmachine` \
		--host=$HOST_PREFIX \
		--prefix=/usr \
		--with-openssl=no \
		--with-rlm-ldap-lib-dir=$STAGING/usr/lib \
		--with-rlm-ldap-include-dir=$STAGING/usr/include \
		--with-modules="rlm_exec" \
		--enable-ltdl-install=yes || exit $?
fi

make $MAKE_OPTS || exit $?
