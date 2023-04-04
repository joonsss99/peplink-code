#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

UTILS_NAME="ping"
if [ "$NO_IPV6" != "y" ]; then
	UTILS_NAME="$UTILS_NAME ping6"
fi

make -C ${FETCHEDDIR} CC=$HOST_PREFIX-gcc KERNEL_INCLUDE=$KERNEL_DIR/include $UTILS_NAME $MAKE_OPTS || exit $?
