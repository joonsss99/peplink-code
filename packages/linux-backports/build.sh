#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

makeflag="ARCH=$KERNEL_ARCH CROSS_COMPILE=$HOST_PREFIX- KLIB_BUILD=$KERNEL_OBJ $MAKE_OPTS"

echo -e "${TCOLOR_BGREEN}building linux backports...${TCOLOR_NORMAL}"
if [ ! -f $FETCHEDDIR/.config ]; then
	echo "${PACKAGE}: .config file is missing"
	exit 1
fi

make -C ${FETCHEDDIR} $makeflag silentoldconfig || exit $?
make -C ${FETCHEDDIR} $makeflag || exit $?
