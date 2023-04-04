#!/bin/sh
PACKAGE=$1

abspath=`pwd`
FETCHEDDIR=${abspath}/${FETCHDIR}/${PACKAGE}


makeflag="CROSS_COMPILE=${HOST_PREFIX}- \
	ARCH=${KERNEL_ARCH} \
	SUBDIRS=${FETCHEDDIR}"

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	makeflag="$makeflag O=$KERNEL_OBJ"
fi

cd $abspath
make -C $KERNEL_SRC $makeflag clean || exit $?
