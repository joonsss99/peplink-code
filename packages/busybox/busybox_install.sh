#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
objtree="$abspath/$OBJTREE/busybox"
upgrd_tree="$abspath/$UPGRADER_OBJTREE/busybox"

# objtree
make -C $FETCHEDDIR install O=$objtree CROSS_COMPILE=$HOST_PREFIX- || exit $?
[ -d $objtree/_install ] || exit 1
cp -pRf $objtree/_install/* $abspath/$MNT || exit 1

if [ "${PL_BUILD_ARCH}" = "powerpc"  ]; then
	ln -snf bin/busybox $abspath/$MNT/init
fi

# install objtree busybox to kdump
if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	cp -pRf $objtree/_install/* $abspath/$KDUMP_ROOT_DIR || exit 1
fi

if [ "$HAS_UPGRADER" != "y" ]; then
	exit 0
fi

# upgrd_tree
make -C $FETCHEDDIR install O=$upgrd_tree CROSS_COMPILE=$HOST_PREFIX- || exit $?
[ -d $upgrd_tree/_install ] || exit 1
[ ! -d $UPGRADER_ROOT_DIR ] && mkdir -p $UPGRADER_ROOT_DIR
mkdir -p ${abspath}/${UPGRADER_ROOT_DIR}/tmp
mkdir -p ${abspath}/${UPGRADER_ROOT_DIR}/dev
cp -pRf $upgrd_tree/_install/* $abspath/$UPGRADER_ROOT_DIR || exit 1

