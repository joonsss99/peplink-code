#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

make -C $FETCHEDDIR all $MAKE_OPTS || exit $?
make -C $FETCHEDDIR DESTDIR=${STAGING} install-dev || exit $?
