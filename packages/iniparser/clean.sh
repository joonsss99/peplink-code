#!/bin/sh

PACKAGE=$1
FETCHEDDIR=$FETCHDIR/$PACKAGE

. ./make.conf

make $MAKE_OPTS -C $FETCHEDDIR CC=$HOST_PREFIX-gcc AR=$HOST_PREFIX-ar clean || exit $?
