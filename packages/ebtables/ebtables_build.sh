#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ "${BUILD_TARGET}" = "maxotg" ]; then
	ebt_ext="limit arpreply 802_3 mark_m mark among redirect"
	for i in $ebt_ext; do
		sed -i -e "s/${i} //g" -e "s/${i}$//g" $FETCHEDDIR/userspace/ebtables2/extensions/Makefile || exit $?
	done
fi

make -C $FETCHEDDIR/userspace/ebtables2 CC=$HOST_PREFIX-gcc LIBDIR="/usr/lib/ebtables" LD=$HOST_PREFIX-ld CFLAGS=${MYCFLAGS} KERNEL_INCLUDES=$STAGING/usr/include
