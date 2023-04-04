#!/bin/sh

PACKAGE=$1

abspath=`pwd`

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

make -C $FETCHEDDIR/src CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS \
	TIMESYNC_INIT="/var/run/ilink/time_initialized" \
	TARGET_SERIES="$TARGET_SERIES" \
	|| exit $?
