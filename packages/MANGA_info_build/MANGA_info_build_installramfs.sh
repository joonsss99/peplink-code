#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

#build date
mkdir -p ${abspath}/${RAMFS_ROOT}/etc
abspath="$abspath" ${abspath}/${PACKAGESDIR}/${PACKAGE}/MANGA_version.sh -v ${FIRMWARE_VERSION} > ${abspath}/${RAMFS_ROOT}/etc/software-release
abspath="$abspath" ${abspath}/${PACKAGESDIR}/${PACKAGE}/MANGA_version.sh -d > ${abspath}/${RAMFS_ROOT}/etc/MANGA_buildno

case ${BUILD_MODEL} in
bs)
#PL_BUILD_ARCH is defined in balance.profile
if [ "${PL_BUILD_ARCH}" = "ar7100" ]; then
	cp -f $abspath/keys/partition/ar71xx/cryptsetup.key $abspath/$RAMFS_ROOT/etc/ck
	cp -pf ${RAMFS_PUBLIC_KEY} ${RAMFS_ROOT}/etc/public.key
fi
if [ "$BUILD_TARGET" = "ipq64" -o "$BUILD_TARGET" = "aponeax" ]; then
	cp -f $abspath/keys/partition/ipq64/part1.key $abspath/$RAMFS_ROOT/etc/ckp1
	cp -f $abspath/keys/partition/ipq64/part2.key $abspath/$RAMFS_ROOT/etc/ckp2
	cp -f $abspath/keys/partition/ipq64/stor.key $abspath/$RAMFS_ROOT/etc/ckst
fi
;;
esac
