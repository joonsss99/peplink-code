#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR/build ; tar -cf - . | tar -C $abspath/$MNT --keep-directory-symlink -xf -
