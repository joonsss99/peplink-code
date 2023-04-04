#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

# CFLAGS must be set as environment variable instead of 
# make variable to allow Makefile to include the env{CFLAGS}
# otherwise, as make variable it will override the CFLAGS
# in the makefile
KERNEL_INCLUDE="$STAGING/usr/include" CFLAGS="-I$STAGING/usr/include" make -C $FETCHEDDIR \
	CC=$HOST_PREFIX-gcc AR=$HOST_PREFIX-ar \
	TC_CONFIG_NO_XT=y \
	TC_CONFIG_ELF=n \
	SUBDIRS="lib ip tc bridge" \
	$MAKE_OPTS || exit $?

