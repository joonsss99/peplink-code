#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

tools="usr/lib/libwget.so"

for t in $tools ; do
	mkdir -p `dirname $abspath/${RAMFS_ROOT}/$t`
	cp -Pp $STAGING/$t $abspath/${RAMFS_ROOT}/$t || exit $?
	$HOST_PREFIX-strip $abspath/$RAMFS_ROOT/$t
done

