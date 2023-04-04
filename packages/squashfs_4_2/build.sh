#!/bin/sh

PACKAGE=$1
FETCHEDDIR=$FETCHDIR/$PACKAGE

abspath=`pwd`

[ -x $HOST_TOOL_DIR/bin/mksquashfs ] && exit 0

host_include=$abspath/tmp/usr/local/include
host_lib=$abspath/tmp/usr/local/lib

make \
	EXTRA_CFLAGS="-I${host_include}" \
	EXTRA_LDFLAGS="-L${host_lib}" \
	-C $FETCHEDDIR/squashfs-tools || exit $?

cp -f $FETCHEDDIR/squashfs-tools/mksquashfs $HOST_TOOL_DIR/bin/
