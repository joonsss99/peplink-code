#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

mkdir -p ${abspath}/${MNT}/etc
# firmware version, note: buildbot will override this value
abspath="$abspath" ${abspath}/${PACKAGESDIR}/${PACKAGE}/MANGA_version.sh -v ${FIRMWARE_VERSION} > ${abspath}/${MNT}/etc/software-release
if [ x$FW_CONFIG_KDUMP = xy ] ; then
	abspath="$abspath" ${abspath}/${PACKAGESDIR}/${PACKAGE}/MANGA_version.sh -v ${FIRMWARE_VERSION} > $abspath/$KDUMP_ROOT_DIR/panic_fwver
fi

# build number
abspath="$abspath" ${abspath}/${PACKAGESDIR}/${PACKAGE}/MANGA_version.sh -d > ${abspath}/${MNT}/etc/MANGA_buildno

# config version
echo ${CFG_VERSION} > ${abspath}/${MNT}/etc/compatible_cfg_version

if [ "$BLD_CONFIG_FWKEY_V3_ED25519" != "y" ] || \
   [ "$BLD_CONFIG_FWKEY_V3_ED25519" = "y" -a "$BLD_CONFIG_FWKEY_LEGACY_V2_DOWNGRADE" = "y" ] ; then
	#
	# By default we create /etc/public.key from the first model in FIRMWARE_MODEL_LIST.
	# For multi-model firmware, bootup script would create symlink from public.key.$model
	#
	cp -pf $abspath/keys/firmware/public.key.${FIRMWARE_MODEL_LIST%% *} $abspath/$MNT/etc/public.key || exit 1
	for m in $FIRMWARE_MODEL_LIST; do
		cp -pf $abspath/keys/firmware/public.key.$m $abspath/$MNT/etc/ || exit 1
	done
fi

if [ "$BLD_CONFIG_ENCRYPT_FIRMWARE" = "y" ]; then
	cp -pf $abspath/keys/rdisk/private.key.${FIRMWARE_MODEL_LIST%%\ *} $abspath/$MNT/etc/rd || exit 1
fi

case ${BUILD_MODEL} in
bs)
	echo -n "${MODEM_PACKAGE_VERSION}" > ${abspath}/${MNT}/etc/modem_package_version

	case $BUILD_TARGET in
	balance700|balance2500|apx)
		cp -fp $abspath/$LICENSE_PUBLIC_KEY $abspath/$MNT/etc/.bsl.key
		;;
	m700|maxotg|maxdcs|maxdcs_ipq|maxbr1ac|maxhd4|maxdcs_ppc|plsw|ipq|vbal|apone|aponeac|aponeax|ipq64|mtk5g|ramips|maxdcs_ramips|sfchn)
		;;
	*)
		echo "invalid BUILD_TARGET ${BUILD_TARGET}"
		exit 1
		;;
	esac
	;;
fh)
	;;
*)
	echo "invalid MODEL ${BUILD_MODEL}"
	exit 1
	;;
esac
