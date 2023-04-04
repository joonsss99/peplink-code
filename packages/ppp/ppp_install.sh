#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ "${PL_BUILD_ARCH}" != "ixp" -a "${PL_BUILD_ARCH}" != "ar7100" ]; then
#remove pppd in ramdisk base
	rm -rf $abspath/$MNT/lib/pppd
	rm -f ${abspath}/${MNT}/usr/sbin/pppd
	rm -f $abspath/$MNT/usr/sbin/pppstats
fi
rm -rf ${abspath}/${MNT}/etc/radiusclient/*

install -s --strip-program=${HOST_PREFIX}-strip \
	-D -t "${abspath}/${MNT}/sbin" \
	"${FETCHEDDIR}/pppd/pppd" \
	"${FETCHEDDIR}/pppstats/pppstats" \
	"${FETCHEDDIR}/chat/chat" \
	|| exit $?

mkdir -p ${abspath}/${MNT}/usr/sbin
ln -sf /sbin/chat ${abspath}/${MNT}/usr/sbin/chat

install -s --strip-program=${HOST_PREFIX}-strip \
	--mode=444 -D -t "${abspath}/${MNT}/etc/ppp/plugins" \
	"${FETCHEDDIR}/pppd/plugins/rp-pppoe/rp-pppoe.so" \
	"${FETCHEDDIR}/pppd/plugins/dhcp/dhcpc.so" \
	"${FETCHEDDIR}/pppd/plugins/radius/radius.so" \
	|| exit $?

install -s --strip-program=${HOST_PREFIX}-strip \
	--mode=444 -D -t "${abspath}/${MNT}/usr/local/lib/pppd/2.4.5/" \
	"${FETCHEDDIR}/pppd/plugins/pppol2tp/pppol2tp.so" \
	"${FETCHEDDIR}/pppd/plugins/pppol2tp/openl2tp.so" \
	|| exit $?

install --mode=644 -D -t ${abspath}/${MNT}/etc/radiusclient \
	${FETCHEDDIR}/pppd/plugins/radius/etc/dictionary \
	${FETCHEDDIR}/pppd/plugins/radius/etc/dictionary.microsoft \
	${FETCHEDDIR}/pppd/plugins/radius/etc/dictionary.other \
	${FETCHEDDIR}/pppd/plugins/radius/etc/issue \
	${FETCHEDDIR}/pppd/plugins/radius/etc/port-id-map \
	${FETCHEDDIR}/pppd/plugins/radius/etc/radiusclient.conf \
	${FETCHEDDIR}/pppd/plugins/radius/etc/realms \
	${FETCHEDDIR}/pppd/plugins/radius/etc/servers \
	|| exit $?
