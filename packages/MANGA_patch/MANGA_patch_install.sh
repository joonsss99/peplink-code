#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ "${abspath}/${MNT}" = "/" ]; then
	echo_error "${PACKAGE}: abspath and MNT are empty!"
	exit 1;
fi

# dummy arch check
case $PL_BUILD_ARCH in
x86|x86_64|ixp|ar7100|powerpc|arm|arm64|ramips)
	true
	;;
*)
	echo_error "arch $PL_BUILD_ARCH not supported"
	exit 1
	;;
esac

# ****************************************************************************
#
# Please THINK AGAIN before you add stuff here. You probably can do it
# in some other project's install script.
#
# ****************************************************************************

mkdir -p $abspath/$MNT/etc
if [ "${BUILD_TARGET}" = "m700" ]; then
	cp -f ${abspath}/keys/partition/ar71xx/cryptsetup.key $abspath/$MNT/etc/ck
elif [ "${BUILD_TARGET}" = "fhvm" ]; then
	cp -f ${abspath}/keys/partition/fhvm/part*.key $abspath/$MNT/etc/
elif [ "${BUILD_TARGET}" = "apx" ]; then
	cp -f ${abspath}/keys/partition/apx/part* $abspath/$MNT/etc/
	if [ "$FW_CONFIG_KDUMP" = "y" -a "$KDUMP_DM_CRYPT_PARTITION" = "y" ]; then
		cp -f ${abspath}/keys/partition/apx/part4 $abspath/$KDUMP_ROOT_DIR/.data
	fi
elif [ "${BUILD_TARGET}" = "vbal" ]; then
	cp -f ${abspath}/keys/partition/vbal/part* $abspath/$MNT/etc/
fi

rm -Rf `find ${abspath}/${MNT} -name CVS`
rm -Rf `find ${abspath}/${MNT} -name "*~"`

if [ "${BUILD_TARGET}" = "maxotg" -o "${BUILD_TARGET}" = "maxdcs" -o \
	   "${BUILD_TARGET}" = "maxbr1ac" -o "${BUILD_TARGET}" = "aponeac" -o "${BUILD_TARGET}" = "sfchn" ]; then
	# Temporary
	rm ${abspath}/${MNT}/usr/lib/hotplug/firmware/macxvi350.bin
#	mips-peplink-linux-strip --strip-debug ${abspath}/${MNT}/lib/modules/2.6.28.10/wlan/*
fi

#balance200/300 put timezone info at /usr/share/zoneinfo/Etc
ln -sf /usr/local/arm/arm-linux/etc/localtime ${abspath}/${MNT}/etc/localtime

# Remove obsoleted connection icon images
rm -f ${abspath}/${MNT}/web/en/images/connicon*.png


# Remove files for maxotg build target to saving disk space
if [ "${BUILD_TARGET}" = "maxotg" ]; then
	# remove .woff2 files
	rm -f `find ${abspath}/${MNT}/web/ | grep ".woff2$"`
	# remove vdsl files
	rm -f `find ${abspath}/${MNT}/ -name "*vdsl*"`
	# remove adsl files
	rm -f `find ${abspath}/${MNT}/ -name "*adsl*"`
	# remove lora files
	rm -rf `find ${abspath}/${MNT}/ -name "*lora*"`
	# remove rsim_server files
	rm -rf `find ${abspath}/${MNT}/ -name "*rsim_server*"`
	# remove patton files
	rm -rf `find ${abspath}/${MNT}/ -name "*patton*"`
fi

