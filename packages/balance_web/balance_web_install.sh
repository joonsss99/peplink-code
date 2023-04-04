#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

mkdir -p ${abspath}/${MNT}/web
cp -Rpf ${FETCHEDDIR}/build/* ${abspath}/${MNT}/web
mkdir -p ${abspath}/${MNT}/usr/local/ilink/bin

# [Bug#21392] Remove unneeded image files (as ran out of firmware space)
if expr match "${BLD_CONFIG_FW_MODEL_LIST}" "pwmaxotg" > /dev/null; then
	WHITE_LIST="peplink pepwave pepxim"
	for I in \
		${abspath}/${MNT}/web/MANGA/images/login_clean_* \
		${abspath}/${MNT}/web/MANGA/images/toplogo_* \
		${abspath}/${MNT}/web/en/images/favicon_* \
	; do
		MATCHED=
		for KEY in ${WHITE_LIST}; do
			if expr match "${I}" ".*${KEY}.*" > /dev/null; then
				MATCHED="yes"
				break
			fi
		done
		[ -z "${MATCHED}" ] && rm -f "${I}"
	done
fi

# This path is gone for long, and I wonder if anyone demand this linkusage in bin still
#	removed by Kenny Kwok, 2012/08/15
#cp -pf ${FETCHEDDIR}/linkusage/linkusage ${abspath}/${MNT}/usr/local/ilink/bin

#PL_BUILD_ARCH is defined in balance.profile
if [ "${PL_BUILD_ARCH}" = "x86" -o "${PL_BUILD_ARCH}" = "x86_64" ]; then
BINTARGET=x86
elif [ "${PL_BUILD_ARCH}" = "ixp" ]; then
BINTARGET=ixp
cd ${FETCHEDDIR}/src/cgi
./make_up.sh ${BINTARGET}
cd ${abspath}
cp -pf ${FETCHEDDIR}/src/cgi/config_upgrade ${abspath}/${MNT}/usr/local/ilink/bin
elif [ "${PL_BUILD_ARCH}" = "ar7100" ]; then
BINTARGET=mips
cd ${FETCHEDDIR}/src/cgi
./make_up.sh ${BINTARGET}
cd ${abspath}
cp -pf ${FETCHEDDIR}/src/cgi/config_upgrade ${abspath}/${MNT}/usr/local/ilink/bin
# Remove highstock.js.map, networkgraph.js.map for ar7100
rm -f ${abspath}/${MNT}/web/MANGA/highstock.js.map
rm -f ${abspath}/${MNT}/web/MANGA/networkgraph.js.map
# Remove MDM related images
rm -f ${abspath}/${MNT}/web/en/images/ios_defaultapp.png
rm -f ${abspath}/${MNT}/web/en/images/ios_settings.png
else
BINTARGET=ks8695
cd ${FETCHEDDIR}/src/cgi
./make_up.sh ${BINTARGET}
cd ${abspath}
cp -pf ${FETCHEDDIR}/src/cgi/config_upgrade ${abspath}/${MNT}/usr/local/ilink/bin
$HOST_PREFIX-strip ${abspath}/${MNT}/usr/local/ilink/bin/config_upgrade
fi

if [ "${BUILD_TARGET}" = "m600" ]; then
	if [ "`grep wwan_status_daemon ${abspath}/${MNT}/etc/inittab`" = "" ]; then
		inittab_install $abspath add respawn "/web/cgi-bin/MANGA/wwan_status_daemon"
	fi
fi
