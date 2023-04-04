#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

case $PL_BUILD_ARCH in
ixp|ar7100|powerpc)
	EXTRA_OPT="CONFIG_NEED_RESOLV=y"
	;;
esac

make -C ${FETCHEDDIR} $EXTRA_OPT $MAKE_OPTS || exit $?

