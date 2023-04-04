#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

upnp_bin=$FETCHEDDIR/miniupnpd

[ ! -f $upnp_bin ] && echo "missing binary $upnp_bin" && exit 1

mkdir -p ${abspath}/${MNT}/usr/sbin

cp -Rpf $FETCHEDDIR/miniupnpd $abspath/$MNT/usr/sbin || exit 1
cp -Rpf $FETCHEDDIR/miniupnpdctl $abspath/$MNT/usr/sbin || exit 1

${HOST_PREFIX}-strip $abspath/$MNT/usr/sbin/miniupnpd || exit 1
${HOST_PREFIX}-strip $abspath/$MNT/usr/sbin/miniupnpdctl || exit 1

exit 0

