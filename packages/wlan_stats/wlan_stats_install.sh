#!/bin/sh

PACKAGE=$1

. ${PACKAGESDIR}/common/common_functions

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

dest=${abspath}/${MNT}/usr/local/ilink/bin
mkdir -p ${dest}

if [ "${BLD_CONFIG_WLAN_LEGACY}" = "y" ]; then
	cp -pPf ${FETCHEDDIR}/vnstat-1.11/src/vnstatm ${dest}/ || exit $?
	$HOST_PREFIX-strip ${dest}/vnstatm
	cp -pPf ${FETCHEDDIR}/create_client_table/create_client_table ${dest}/ || exit $?
	cp -pPf ${FETCHEDDIR}/create_client_table/client_table_map ${dest}/ || exit $?
fi
cp -pPf ${FETCHEDDIR}/schedule/generate_auto_wpa_key ${dest}/ || exit $?
