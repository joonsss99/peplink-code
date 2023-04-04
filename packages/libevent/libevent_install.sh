#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

#. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

(cd $STAGING && tar -cf - usr/lib/libevent*so*) | tar -C $abspath/$MNT -xf -

$HOST_PREFIX-strip $abspath/$MNT/usr/lib/libevent*so*
