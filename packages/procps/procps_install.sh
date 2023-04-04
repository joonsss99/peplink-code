#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

[ ! -f ${FETCHEDDIR}/_install/bin/ps ] && echo "missing binary" && exit 1

cd $FETCHEDDIR/_install

applist="bin/ps lib/libproc*so* bin/top bin/vmstat"
[ "${BLD_CONFIG_BALANCE_FULL_FEATURE}" = "y" ] && applist="$applist bin/slabtop"

tar cf - $applist | tar xf - -C $abspath/$MNT || exit $?
for a in $applist ; do
	$HOST_PREFIX-strip $abspath/$MNT/$a
done
