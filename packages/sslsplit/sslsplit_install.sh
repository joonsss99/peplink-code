#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

install -s --strip-program=${HOST_PREFIX}-strip \
	-D -t $abspath/$MNT/usr/local/ilink/bin/ \
	$FETCHEDDIR/sslsplit || exit $?
