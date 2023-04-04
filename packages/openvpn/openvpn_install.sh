#!/bin/sh

PACKAGE=$1

FETCHEDDIR=$FETCHDIR/$PACKAGE

abspath=`pwd`

OPENVPN_BIN="${abspath}/${MNT}/usr/bin"
OPENVPN_DIR="$abspath/$MNT/var/run/ilink/openvpn"

mkdir -p ${OPENVPN_BIN}
cp -f ${FETCHEDDIR}/src/openvpn/openvpn ${OPENVPN_BIN}/
$HOST_PREFIX-strip --strip-all ${OPENVPN_BIN}/openvpn || exit $?

mkdir -p ${OPENVPN_DIR}
cp -frp ${FETCHEDDIR}/pepos_conf/* ${OPENVPN_DIR}/

cp -frp ${FETCHEDDIR}/src/plugins/dhcpc-unix/openvpn_dhcpc_unix ${OPENVPN_BIN}/
$HOST_PREFIX-strip --strip-all ${OPENVPN_BIN}/openvpn_dhcpc_unix || exit $?
