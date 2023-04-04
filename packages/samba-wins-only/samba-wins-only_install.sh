#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

subdir="etc var usr sbin"
for s in $subdir ; do
	cp -rfp $FETCHEDDIR/build/$s/*  $abspath/$MNT/$s/
done

for i in libtalloc libtdb libtevent; do
	cp -rfp $FETCHEDDIR/source3/bin/$i.so*  $abspath/$MNT/usr/lib/ || exit $?
	${HOST_PREFIX}-strip $abspath/$MNT/usr/lib/$i.so* || exit $?
done
