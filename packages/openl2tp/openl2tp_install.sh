#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR
mkdir -p ${abspath}/${MNT}/usr/sbin/
cp -f openl2tpd ${abspath}/${MNT}/usr/sbin/ || exit 1
$HOST_PREFIX-strip $abspath/${MNT}/usr/sbin/openl2tpd
rm -f $abspath/$MNT/usr/sbin/openl2tps
ln -s openl2tpd $abspath/$MNT/usr/sbin/openl2tps
mkdir -p ${abspath}/${MNT}/usr/lib/openl2tp || exit 1
cp -f plugins/*.so ${abspath}/${MNT}/usr/lib/openl2tp/ || exit 1
$HOST_PREFIX-strip --strip-unneeded ${abspath}/${MNT}/usr/lib/openl2tp/*.so

mkdir -p ${abspath}/${MNT}/var/run/ilink/l2tps || exit 1

cd $abspath

