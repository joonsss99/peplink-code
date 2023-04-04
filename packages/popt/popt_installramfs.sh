#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

tools="usr/lib/libpopt.so usr/lib/libpopt.so.0 usr/lib/libpopt.so.0.0.0"

for t in $tools ; do
	mkdir -p `dirname $abspath/${RAMFS_ROOT}/$t`
	cp -Pp $STAGING/$t $abspath/${RAMFS_ROOT}/$t || exit $?
	if [ ! -L "$STAGING/$t" ]; then
		$HOST_PREFIX-strip $abspath/$RAMFS_ROOT/$t
	fi
done

