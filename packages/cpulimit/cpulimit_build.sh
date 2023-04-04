#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

make -C $FETCHEDDIR $MAKE_OPTS CC=$HOST_PREFIX-gcc || exit$?
