#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

mkdir -p $abspath/$RAMFS_ROOT/usr/bin
mkdir -p $abspath/$RAMFS_ROOT/usr/lib

make -C $FETCHEDDIR DESTDIR=$abspath/$RAMFS_ROOT install_runtime
rm -f $abspath/$RAMFS_ROOT/usr/bin/openssl
rm -f $abspath/$RAMFS_ROOT/usr/bin/c_rehash
$HOST_PREFIX-strip $abspath/$RAMFS_ROOT/usr/lib/libcrypto.so.*
$HOST_PREFIX-strip $abspath/$RAMFS_ROOT/usr/lib/libssl.so.*
