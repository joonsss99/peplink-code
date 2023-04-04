#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

bin_utils="flock hwclock setsid"
mkdir -p $abspath/$MNT/bin
for u in $bin_utils ; do
	cp -pf $FETCHEDDIR/$u $abspath/$MNT/bin
	$HOST_PREFIX-strip $abspath/$MNT/bin/$u
done

mkdir -p $abspath/$MNT/sbin
if [ "${HAS_STORAGE_MGMT_TOOLS}" = "y" ]; then
	sbin_utils="sfdisk"
	for u in $sbin_utils ; do
		cp -pf $FETCHEDDIR/$u $abspath/$MNT/sbin
		$HOST_PREFIX-strip $abspath/$MNT/sbin/$u
	done
fi
