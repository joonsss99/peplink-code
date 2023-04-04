#!/bin/sh

PACKAGE=$1

abspath=`pwd`
. ./make.conf
. ${PACKAGESDIR}/common/common_functions

FETCHEDDIR=${FETCHDIR}/${PACKAGE}
PISMO_SERIALNET_ABSPATH=${abspath}/${FETCHEDDIR}

make install_app -C $FETCHEDDIR \
	CROSS_COMPILE_PREFIX=$HOST_PREFIX- || exit $?

cd $PISMO_SERIALNET_ABSPATH/apps/build ; tar -cf - . | tar --keep-directory-symlink -C $abspath/$MNT -xf -
