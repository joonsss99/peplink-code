#!/bin/sh

PACKAGE=speedfusion

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

LIBDIRS="libvpnsync libvpnstatus"

. ${PACKAGESDIR}/common/common_functions

for i in ${LIBDIRS}; do
	make -C ${FETCHEDDIR}/${i} ARCH=$KERNEL_ARCH clean
done
