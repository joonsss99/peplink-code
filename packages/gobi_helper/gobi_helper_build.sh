#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

# Build gobi_helper
make -C $FETCHEDDIR all $MAKE_OPTS || exit $?
make -C $FETCHEDDIR install || exit $?
