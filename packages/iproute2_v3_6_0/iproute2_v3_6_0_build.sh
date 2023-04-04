#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

make -C $FETCHEDDIR \
	CFLAGS="\$(CCOPTS) -I$STAGING/usr/include -I../include \$(DEFINES)" \
	CC=$HOST_PREFIX-gcc AR=$HOST_PREFIX-ar \
	SUBDIRS="lib ip tc" \
	TARGETS=ip \
	$MAKE_OPTS || exit $?

