#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR

make binaries_install PEPLINK=1 STRIP=${HOST_PREFIX}-strip DESTDIR=${abspath}/${MNT} PREFIX=/usr
