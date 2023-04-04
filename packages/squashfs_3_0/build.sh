#!/bin/sh

PACKAGE=$1
FETCHEDDIR=$FETCHDIR/$PACKAGE

[ -x $HOST_TOOL_DIR/bin/mksquashfs-lzma ] && exit 0

make -C $FETCHEDDIR/lzma/C/7zip/Compress/LZMA_Lib || exit $?
make -C $FETCHEDDIR/squashfs-tools || exit $?

cp -f $FETCHEDDIR/squashfs-tools/mksquashfs-lzma $HOST_TOOL_DIR/bin/
