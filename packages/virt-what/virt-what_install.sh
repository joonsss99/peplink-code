#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

scriptfiles="virt-what"
binfiles="virt-what-cpuid-helper"

for f in $binfiles
do
	if [ ! -f ${FETCHEDDIR}/${f} ]; then
		echo "missing binary in $FETCHEDDIR/$f" && exit 1
	fi
done

for f in $scriptfiles
do
	if [ ! -f ${FETCHEDDIR}/${f} ]; then
		echo "missing scripts in $FETCHEDDIR/$f" && exit 1
	fi
done

cd $FETCHEDDIR
cp -Rpf ${binfiles} ${scriptfiles} ${abspath}/${MNT}/usr/local/ilink/bin || exit $?

for f in ${binfiles}
do
	$HOST_PREFIX-strip ${abspath}/${MNT}/usr/local/ilink/bin/${f} || exit $?
done

cd ${abspath}
