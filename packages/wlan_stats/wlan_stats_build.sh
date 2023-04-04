#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
make_opt=""
make_define=""

if [ "${BLD_CONFIG_WLAN_LEGACY}" = "y" ]; then
	make_opt="all"
else
	# only build generate_auto_wpa_key if not legacy wlan component
	make_opt="generate_auto_wpa_key"
fi
[ "${BLD_CONFIG_WLC}" = "y" ] && make_define="HAS_WLC=y"

make -C ${FETCHEDDIR} ${make_opt} ${make_define} || exit $?
