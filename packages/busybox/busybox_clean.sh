#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=$(pwd)
objtree="$abspath/$OBJTREE/busybox"
upgdr_tree="$abspath/$UPGRADER_OBJTREE/busybox"

for obj in "$objtree" "$upgdr_tree"; do
	if [ -d "$obj" ]; then
		make -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- O="$obj" $MAKE_OPTS distclean
	fi
done
