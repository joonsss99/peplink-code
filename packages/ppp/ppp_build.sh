#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

# pppd will link with "-llbout" if CONFIG_PPP_ILINK_OUT_SUPPORT=y
# FusionHub has BLD_CONFIG_BALANCE_KMOD defined but does not build lbout
# Some Balance/MAX models may not define BLD_CONFIG_BALANCE_KMOD
# Following checking fit above requirements
[ "$BUILD_MODEL" = "bs" -a "${BLD_CONFIG_BALANCE_KMOD}" = "y" ] && MAKE_OPTS="$MAKE_OPTS CONFIG_PPP_ILINK_OUT_SUPPORT=y"
MAKE_OPTS="$MAKE_OPTS PISMO_RADIUS_STATISTICS=y PISMO_RADIUS_BINDADDR=y"

cd ${FETCHEDDIR} || exit $?
if [ ! -f pppd/pppd ]; then
	./configure || exit $?
	perl -i -ape 's/^FILTER=\S+/#FILTER=y/' pppd/Makefile || exit $?
fi
make CC=$HOST_PREFIX-gcc AR=$HOST_PREFIX-ar $MAKE_OPTS || exit 1
