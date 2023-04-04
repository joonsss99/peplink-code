#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

if [ "${PL_BUILD_ARCH}" = "ixp" -o "${PL_BUILD_ARCH}" = "ar7100" -o "${PL_BUILD_ARCH}" = "powerpc" ]; then
# Patch
perl -i -ape 's/-DLIBNET_LIL_ENDIAN/-DLIBNET_BIG_ENDIAN/' ${FETCHEDDIR}/libnet/libnet-config
perl -i -ape 's/#define LIBNET_LIL_ENDIAN 1/\/* #undef LIBNET_LIL_ENDIAN *\//' ${FETCHEDDIR}/libnet/include/config.h
perl -i -ape 's/\/\* #undef LIBNET_BIG_ENDIAN \*\//#define LIBNET_BIG_ENDIAN 1/' ${FETCHEDDIR}/libnet/include/config.h
fi
make -C ${FETCHEDDIR} BALANCE_SCRIPT_PATH=../balance_scripts/src \
	CROSS_PREFIX=$HOST_PREFIX- \
	CC=$HOST_PREFIX-gcc \
	AR=$HOST_PREFIX-ar \
	RANLIB=$HOST_PREFIX-ranlib \
	$MAKE_OPTS || exit $?
