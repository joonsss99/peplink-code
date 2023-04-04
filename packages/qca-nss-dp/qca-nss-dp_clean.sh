#!/bin/sh
PACKAGE=$1

abspath=`pwd`
FETCHEDDIR=${abspath}/${FETCHDIR}/${PACKAGE}

make -C "${KERNEL_SRC}" \
	CROSS_COMPILE="${HOST_PREFIX}-" \
	ARCH="${KERNEL_ARCH}" \
	SUBDIRS="${FETCHEDDIR}" \
	clean || exit $?
