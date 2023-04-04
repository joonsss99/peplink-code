#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

#note: patch command will look at TMP 
#      will conflict with build system
#      we need to remember the old value
#      then reset it after 'patch' command
OLDTMP=${TMP}
TMP=/tmp

abspath=`pwd`

PATCH_FILES="Makefile.patch ping-s20100418.patch traceroute6.patch ping6.patch" 

cd ${FETCHEDDIR}/iputils-s20100418
for p in $PATCH_FILES; do
	patch -t -N --verbose -p1 < ../patches/$p
done

TMP=${OLDTMP}
cd ${abspath}
