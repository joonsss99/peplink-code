#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR || exit $?

conf_args="--disable-lsmtd \
	--disable-tests \
	--without-jffs \
	--without-ubifs \
	--without-xattr \
	--without-lzo \
	--without-zstd \
	--without-crypto"

if [ ! -f configure ]; then
	./autogen.sh || exit $?
fi

if [ ! -e Makefile ] ; then
	./configure --prefix=/usr --host=$HOST_PREFIX $conf_args || exit $?
fi

make $MAKE_OPTS || exit $?
