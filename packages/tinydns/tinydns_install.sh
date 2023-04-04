#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

bins="tinydns run-tinydns-balance axfrdns axfr-get"

mkdir -p $abspath/$MNT/var/run/ilink/tinydns-data
for b in $bins ; do
	if [ ! -f $FETCHEDDIR/$b ] ; then
		echo "binary $b missing"
		exit 1
	fi
	cp -f $FETCHEDDIR/$b $abspath/$MNT/usr/local/ilink/bin/
	$HOST_PREFIX-strip $abspath/$MNT/usr/local/ilink/bin/$b
done

if [ ! -f $FETCHEDDIR/tinydns-data ]; then
	echo "binary tinydns-data missing"
	exit 1
fi
mkdir -p $abspath/$MNT/etc/tinydns/root
cp -f $FETCHEDDIR/tinydns-data $abspath/$MNT/etc/tinydns/root
$HOST_PREFIX-strip $abspath/$MNT/etc/tinydns/root/tinydns-data
