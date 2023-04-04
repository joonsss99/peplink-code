#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR

if [ ! -d objdir ] ; then
	mkdir objdir
fi

if [ "$BLD_CONFIG_KERNEL_V2_6_28" != "y" ] ; then
	support_netflow=y
fi

prepare_legacy_wlan() {
	local wlan_copts=""
cat > Makefile.prepare_wlan << EOF
include ${WLAN_DIR}/drivers/wlan_modules/wlan.conf
include ${WLAN_DIR}/drivers/wlan_modules/os/linux/BuildCaps.inc
WLAN_COPTS=\$(COPTS)

# Prepare make rule file for legacy wireless stats
all:
	if [ ! -f make.wlan_rules ]; then \\
		echo -e "WLAN_COPTS=\"\$(WLAN_COPTS)\"" >> make.wlan_rules; \\
	fi
EOF
	make -f Makefile.prepare_wlan
}

conf_opts="--prefix=/usr --host=$HOST_PREFIX --disable-applications --disable-manuals \
	--disable-scripts --disable-mibs --enable-mini-agent --disable-snmptrapd-subagent \
	--disable-mib-loading --with-defaults --disable-ipv6 --enable-internal-md5 \
	--disable-testing-code --without-krb5 --without-rpm --with-default-snmp-version=2 \
	--disable-embedded-perl --disable-debugging --with-openssl=yes"

if [ -n "$support_netflow" ]; then
	conf_opts+=" --enable-shared"
else
	conf_opts+=" --disable-shared --enable-static"
fi

# with-openssl must be yes instead of path to openssl, otherwise it would
# override the CPPFLAGS we have given in explicit order

cflags="-DPISMO_IFACE_HANDLE -DDEVICE_CPU_LOAD_HANDLE -DENTERPRISES_OID=23695 -DUNIFIED_ENTERPRISES_OID -DRELOAD_AGENT_ADDRESS"

case $PL_BUILD_ARCH in
ixp|ar7100|powerpc)
	conf_opts="$conf_opts --with-endianness=big"
	cflags="$cflags -s -Os"
	;;
x86*|ramips)
	conf_opts="$conf_opts --with-endianness=little"
	cflags="$cflags -s -O2"
	;;
esac

cflags="-I$STAGING/usr/include $cflags"
cppflags="-I$STAGING/usr/include"
ldflags="-L$STAGING/usr/lib"
libs="-lsqlite3 -lpthread -lstatus -lpepinfo -lstrutils -lpepos -lrt -ljansson"

libnl=""
if [ "$BLD_CONFIG_LINUX_WIRELESS_PACKAGE" = "y" ]; then
	libnl="--with-nl=$STAGING/usr/include/libnl3"
	cflags="-I$STAGING/usr/include/libnl3 $cflags"
	# libnl3 must be before .../usr/include otherwise
	# another netlink/socket.h (from kernel) could be included
	cppflags="-I$STAGING/usr/include/libnl3 $cppflags"
fi

mib_modules="ucd-snmp/vmstat host peplink/balance/device"

if [ -n "$support_netflow" ]; then
	mib_modules+=" ucd-snmp/dlmod"
fi

if [ "${BLD_CONFIG_IOTOOLS}" = "y" ]; then
cflags="$cflags -DSUPPORT_HWMON"
fi

if [ "$BUILD_TARGET" == "plsw" ]; then
	libs="$libs -lswitch"
	ldflags="$ldflags -Wl,-rpath-link=$STAGING/usr/lib"
	mib_modules="$mib_modules mibII/system_mib peplink/balance/custom_stand/if_mib"
	cflags="$cflags -DSUPPORT_EXTSW"
else
	mib_modules="$mib_modules mibII if-mib disman/event peplink/balance/balance_wan peplink/balance/lan"
	mib_modules="$mib_modules peplink/mfa_private peplink/l2tp peplink/balance/gre"
	mib_modules="$mib_modules peplink/balance/cellular peplink/balance/ipsec_vpn"
	mib_modules="$mib_modules peplink/balance/sfp"
	include_wifi_mib=""

	if [ "$BLD_CONFIG_LINUX_WIRELESS_PACKAGE" = "y" ]; then
		include_wifi_mib="yes"
		cflags="$cflags -DLINUXWIRELESS"
	elif [ "$BLD_CONFIG_WLAN_LEGACY" = "y" ]; then
		# Legacy wireless stats
		wlan_copts=""
		include_wifi_mib="yes"
		dir_wlan=${WLAN_DIR}/drivers/wlan_modules
		libstats_path=${WLAN_DIR}/libs/libstats
		libs="$libs -lstats"
		ldflags="$ldflags -L${libstats_path}"
		cflags="$cflags -I${libstats_path} -D_BYTE_ORDER=_BIG_ENDIAN"
		cflags="$cflags -I${dir_wlan} -I${dir_wlan}/include"
		cflags="$cflags -I${dir_wlan}/os/linux/include/ -I${dir_wlan}/lmac/ath_dev"

		prepare_legacy_wlan
		if [ -f make.wlan_rules ]; then
			. ./make.wlan_rules
			# Include legacy wireless stats defines
			cflags="$cflags ${WLAN_COPTS}"
		fi
	fi

	if [ "${include_wifi_mib}" = "yes" ]; then
		mib_modules="$mib_modules peplink/balance/wifi"
	fi
fi

if [ "$BUILD_TARGET" == "maxdcs_ppc" ]; then
mib_modules="$mib_modules peplink/balance/custom_alcatel_express"
fi

if [ "$BLD_CONFIG_SPEEDFUSION" = "y" ]; then
	cflags+=" -DCONFIG_HAS_SPEEDFUSION"
	libs+=" -lvpnstatus"
	mib_modules+=" peplink/balance/pep_vpn"
fi

if [ "$BLD_CONFIG_WLC" = "y" ]; then
wlcstorage=$abspath/fetched/balance_ap_extender/libwlcstorage

cflags="$cflags -I$wlcstorage"
ldflags="$ldflags -L$wlcstorage"
libs="$libs -lwlcstorage"
mib_modules="$mib_modules peplink/wlc"
fi

conf_opts="$conf_opts ac_cv_lib_m_asin=no"

cd objdir
if [ ! -f Makefile ] ; then
        CPPFLAGS="$cppflags" ../configure $conf_opts --with-cflags="$cflags" --with-mib-modules="$mib_modules" --with-ldflags="$ldflags" --with-libs="$libs" $libnl || exit $?
fi

make $MAKE_OPTS || exit $?
make -C $abspath/$FETCHEDDIR/src snmpconf CC=$HOST_PREFIX-gcc CFLAGS="${cflags} ${ldflags}" LDFLAGS="${libs}" CPPFLAGS="${cppflags}" $MAKE_OPTS || exit $?

if [ -n "$support_netflow" ]; then
	mkdir -p ${STAGING}/usr/include/net-snmp
	mkdir -p ${STAGING}/usr/include/net-snmp/agent
	cp -dpRf include/net-snmp/* ../include/net-snmp/* ${STAGING}/usr/include/net-snmp/ || exit $?
	cp -dpRf snmplib/.libs/libnetsnmp.so* ${STAGING}/usr/lib/ || exit $?
fi
