#!/bin/sh

PACKAGE=$1
FETCHEDDIR=$FETCHDIR/$PACKAGE

. ./make.conf

make $MAKE_OPTS -C $FETCHEDDIR CC=$HOST_PREFIX-gcc AR=$HOST_PREFIX-ar libiniparser.a || exit $?
cp -pf $FETCHEDDIR/libiniparser.a $STAGING/usr/lib/
cp -pf $FETCHEDDIR/src/iniparser.h $FETCHEDDIR/src/dictionary.h $STAGING/usr/include/
