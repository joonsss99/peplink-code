#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`
objtree="$abspath/$OBJTREE/busybox"
upgdr_tree="$abspath/$UPGRADER_OBJTREE/busybox"

if [ ! -d $objtree ] ; then
	mkdir -p $objtree
fi

if [ ! -d $upgdr_tree ] ; then
	mkdir -p $upgdr_tree
fi

#
# objtree/ build
#

make -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- O=$objtree pepos_defconfig || exit $?
make -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- O=$objtree $MAKE_OPTS || exit $?

if [ "$HAS_UPGRADER" != "y" ] ; then
	exit 0
fi

#
# upgdr_tree/ build
#

make -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- O=$upgdr_tree pepos_defconfig || exit $?
make -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- O=$upgdr_tree $MAKE_OPTS || exit $?
