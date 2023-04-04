#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

# because we need plb.bno for building VTSS firmware
if [ "$FW_BUILD_NUMBER" != "n" ] && [ ! -f ${abspath}/plb.bno ]; then
	echo "Build number file missing: ${abspath}/plb.bno"
	exit 1
fi

buildno=$(cat ${abspath}/plb.bno)

for modelhw in $TARGET_OFFLOAD_SW_CFG_LIST; do
	# copy fw image for upgrader packaging
	if [ -f ${abspath}/$FETCHEDDIR/build/${modelhw}/FW_VTSS_${modelhw}-build${buildno}.dat ]; then
		echo -n "Installing FW_VTSS_${modelhw}-build${buildno}.dat to upgrader... "
		cp -fr ${abspath}/$FETCHEDDIR/build/${modelhw}/FW_VTSS_${modelhw}-build${buildno}.dat ${abspath}/images/FW_VTSS_${modelhw}.dat
		if [ $? -eq 0 ]; then
			echo "installed: FW_VTSS_${modelhw}.dat"
		else
			echo "failed"
			exit 1
		fi
	else
		echo "Missing file: FW_VTSS_${modelhw}-build${buildno}.dat !!!!"
		exit 1
	fi
done

exit 0
