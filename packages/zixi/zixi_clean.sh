#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

make -f $PROJECT_MAKE/Makefile -C $FETCHEDDIR/src clean
