#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

. ./make.conf

abspath=`pwd`

# because we need plb.bno for building VTSS firmware
if [ "$FW_BUILD_NUMBER" != "n" ] && [ ! -f ${abspath}/plb.bno ]; then
	echo "Build number file missing: ${abspath}/plb.bno"
	exit 1
fi

# generate build no
abspath="$abspath" ${abspath}/${PACKAGESDIR}/MANGA_info_build/MANGA_version.sh -d > $FETCHEDDIR/build/buildno

# generate software release
abspath="$abspath" ${abspath}/${PACKAGESDIR}/MANGA_info_build/MANGA_version.sh -v ${FIRMWARE_VERSION} > $FETCHEDDIR/build/software-release

for modelhw in $TARGET_OFFLOAD_SW_CFG_LIST; do
	# symlink config file
	ln -snf configs/peplink_switch_${modelhw}.mk $FETCHEDDIR/build/config.mk

	make -C $FETCHEDDIR/build $MAKE_OPTS OBJ=${modelhw} || exit $?
done
