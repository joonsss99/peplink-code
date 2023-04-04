#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd ${FETCHEDDIR}

make install DEPMOD=$HOST_TOOL_DEPMOD
find ${abspath}/${MNT} -name wpa_* -exec ${HOST_PREFIX}-strip {} \;
find ${abspath}/${MNT} -name hostapd* -exec ${HOST_PREFIX}-strip {} \;
find ${abspath}/${MNT} -name athstats -exec ${HOST_PREFIX}-strip {} \;
find ${abspath}/${MNT} -name wlanconfig -exec ${HOST_PREFIX}-strip {} \;
find ${abspath}/${MNT} -name 80211stats -exec ${HOST_PREFIX}-strip {} \;

# EDDY: wlan component will install all wireless_tools
WI_TOOLS_RM_LIST="iwspy iwgetid ifrename"
echo "Remote unnecessary wireless tools: ${WI_TOOLS_RM_LIST}"
for i in $WI_TOOLS_RM_LIST; do
	rm -f ${abspath}/${MNT}/sbin/$i
done

cd ${abspath}

# BUG21673 Remark device is running legacy wlan component
[ "$BLD_CONFIG_WLAN_LEGACY" = "y" ] && touch $abspath/$MNT/etc/wlan-legacy
exit 0
