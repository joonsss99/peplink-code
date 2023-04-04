#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

make -C ${FETCHEDDIR} clean

# No one should be changing Makefile, instead change Makefile.in for
# long lasting effect
cd $abspath/$FETCHEDDIR && git checkout -- Makefile
rm -rf $abspath/$FETCHEDDIR/_install/
