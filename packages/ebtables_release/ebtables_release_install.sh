#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

binbase=$FETCHEDDIR/userspace/ebtables2

if [ ! -f $binbase/extensions/libebt_vlan.so ]; then
	echo "missing binaries"
	exit 1
fi

ebt_mod_path=$abspath/$MNT/usr/lib/ebtables

mkdir -p $ebt_mod_path
install -m 0755 $binbase/extensions/*.so $ebt_mod_path
install -m 0755 $binbase/*.so $ebt_mod_path
$HOST_PREFIX-strip --strip-unneeded $ebt_mod_path/*.so

cp -pf $binbase/ebtables ${abspath}/${MNT}/bin/
$HOST_PREFIX-strip $abspath/$MNT/bin/ebtables
