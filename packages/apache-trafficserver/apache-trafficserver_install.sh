#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

ATS_SH="${FETCHEDDIR}/tools/tspush"
ATS_PROXY_BIN="${FETCHEDDIR}/proxy/.libs/traffic_server"
ATS_MGMT_BIN="${FETCHEDDIR}/mgmt/.libs/traffic_manager"
ATS_CMD_BIN="${FETCHEDDIR}/cmd/traffic_line/.libs/traffic_line ${FETCHEDDIR}/cmd/traffic_shell/.libs/traffic_shell"
ATS_BIN="${ATS_PROXY_BIN} ${ATS_MGMT_BIN} ${ATS_CMD_BIN}"
ATS_LIB="${FETCHEDDIR}/mgmt/api/.libs/libtsmgmt*.so* ${FETCHEDDIR}/lib/ts/.libs/libtsutil.so*"
ATS_PLUGINS_LIB="${FETCHEDDIR}/plugins/cacheurl/.libs/cacheurl.so ${FETCHEDDIR}/plugins/youtube/.libs/youtube.so"
ATS_PLUGINS_CFG="${FETCHEDDIR}/plugins/cacheurl/cacheurl.config"

$HOST_PREFIX-strip ${ATS_BIN} ${ATS_LIB} ${ATS_PLUGINS_LIB} || exit $?
chmod a+x ${ATS_SH} || exit $?

mkdir -p ${abspath}/${MNT}/usr/bin || exit $?
mkdir -p ${abspath}/${MNT}/usr/lib || exit $?
mkdir -p ${abspath}/${MNT}/tmp/etc/mfa/ats/plugins || exit $?
cp -dpf ${ATS_BIN} ${ATS_SH} ${abspath}/${MNT}/usr/bin/ || exit $?
cp -dpf ${ATS_LIB} ${abspath}/${MNT}/usr/lib/ || exit $?
cp -dpf ${ATS_PLUGINS_LIB} ${ATS_PLUGINS_CFG} ${abspath}/${MNT}/tmp/etc/mfa/ats/plugins/ || exit $?
