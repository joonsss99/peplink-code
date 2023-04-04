#!/bin/sh

PACKAGE=$1
FETCHEDDIR=$FETCHDIR/$PACKAGE

make -C $FETCHEDDIR/squashfs-tools clean || exit $?
