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
x86|x86_64|ar7100|powerpc|arm|arm64|ramips)
	true
	;;
*)
	echo_error "arch $PL_BUILD_ARCH not supported"
	exit 1
	;;
esac

# build target specific stuff
case $BUILD_TARGET in
m700)
	inittab_install $abspath del respawn "/usr/local/ilink/bin/gslb_conf"
	inittab_install $abspath del respawn "/usr/local/ilink/bin/start_tinydns"
	inittab_install $abspath del respawn "/usr/local/ilink/bin/tinydnsdata"
	;;
maxotg|maxbr1|maxdcs|maxdcs_ipq|maxbr1ac|ipq|apone|aponeac|aponeax|ipq64|ramips|maxdcs_ramips|sfchn)
	inittab_install $abspath del respawn "/usr/local/ilink/bin/gslb_conf"
	inittab_install $abspath del respawn "/usr/local/ilink/bin/start_tinydns"
	inittab_install $abspath del respawn "/usr/local/ilink/bin/tinydnsdata"
	inittab_install $abspath del respawn "/usr/local/ilink/bin/gslb_conf"
	inittab_install $abspath del respawn "/usr/local/ilink/bin/start_helper_ipsec"
	;;
plsw)
	inittab_install $abspath add respawn "/usr/local/ilink/bin/start_configd"
	inittab_install $abspath add respawn "/usr/local/ilink/bin/start_sflowtool"
	inittab_install $abspath del respawn "/usr/local/ilink/bin/start_portal_daemon"
	inittab_install $abspath del respawn "/usr/local/ilink/bin/gslb_conf"
	inittab_install $abspath del respawn "/usr/local/ilink/bin/start_tinydns"
	inittab_install $abspath del respawn "/usr/local/ilink/bin/tinydnsdata"
	inittab_install $abspath del respawn "/usr/local/ilink/bin/tcptracerouted"
	;;
esac

# arch specific stuff
case $PL_BUILD_ARCH in
x86|x86_64)
	# We need magicblk/chkrst for "apx" build target
	if [ "${BUILD_TARGET}" != "apx" ]; then
		#don't enable chkrst in x86
		inittab_install $abspath del respawn "/bin/chkrst"
	fi
	if [ "${BUILD_MODEL}" = "fh" ]; then
		console_prog="/usr/local/ilink/bin/fh_console"
	else
		console_prog="/bin/login"
	fi
	if [ "${HOST_MODE}" = "vm" ]; then
		console_port=tty1
	else
		console_port=ttyS0
	fi
	inittab_install $abspath login $console_port $console_prog || exit 1
	;;
ar7100)
	if [ "$BUILD_TARGET" = "maxdcs" -o "$BUILD_TARGET" = "maxbr1ac" -o "$BUILD_TARGET" = "aponeac" ]; then
		inittab_install $abspath login ttyS0 "/bin/login" || exit 1
	else
		inittab_install $abspath login console.real "/bin/login" || exit 1
	fi
	;;
esac

if [ "$BLD_CONFIG_WIFI" = "y" -a "$BLD_CONFIG_LINUX_WIRELESS_PACKAGE" != "y" ]; then
# wtp requires below applications for gathering wifi/sta information
	inittab_install $abspath add respawn "/usr/local/ilink/bin/vnstatm"
	inittab_install $abspath add respawn "/usr/local/ilink/bin/client_table_map"
fi

inittab_install $abspath commit $MNT || exit 1

#balance200/300 put timezone info at /usr/share/zoneinfo/Etc
ln -sf /usr/local/arm/arm-linux/etc/localtime ${abspath}/${MNT}/etc/localtime

#inittab.orig is for ddnrd
#inittab.orig is same as inittab when system boot up
echo "${PACKAGE}: copy inittab to inittab.orig"
cat ${abspath}/${MNT}/etc/inittab
cp -f ${abspath}/${MNT}/etc/inittab ${abspath}/${MNT}/etc/inittab.orig

