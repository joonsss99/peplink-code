#!/bin/sh

PACKAGE=$1

FETCHEDDIR=$FETCHDIR/$PACKAGE

. ./make.conf

if [ "$FW_CONFIG_KDUMP" != "y" ]; then
	echo "kdump not enabled, not building."
	exit 0
fi

cd "${FETCHEDDIR}" || exit $?
if [ -f Makefile ]; then
	make distclean || exit $?
fi
rm -f configure
