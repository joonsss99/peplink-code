#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR

# build host tools required by subsequent make
make chkshsgr auto-str

# clean objects built by host tools as they overlap with cross target
# also need to remove "makelib" so a new "makelib" with properly resolved
# CROSS_PREFIX is created
rm -f *.o makelib

# build cross targets
CROSS_PREFIX=$HOST_PREFIX- make || exit $?
