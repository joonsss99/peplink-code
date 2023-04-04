#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
DIR_SBIN=${abspath}/${MNT}/sbin

cd ${FETCHEDDIR}/staging
tar -cf - sbin/ | tar -xf - -C $abspath/$MNT/
tar -cf - lib/ | tar -xf - -C $abspath/$MNT/
tar -cf - usr/ | tar -xf - -C $abspath/$MNT/

#clean up
rm -f ${abspath}/${MNT}/lib/libxtables.la
rm -f ${abspath}/${MNT}/lib/libip*.la

$HOST_PREFIX-strip $abspath/$MNT/lib/libxtables.so*
$HOST_PREFIX-strip $abspath/$MNT/lib/libip*.so*

USR_LIB_FILES_TO_REMOVE_LIST="libip6* \
	libipt_ah.so \
	libipt_CLUSTERIP.so \
	libipt_ECN.so \
	libipt_MIRROR.so \
	libipt_realm.so \
	libipt_SAME.so \
	libipt_unclean.so \
	libxt_AUDIT.so \
	libxt_CHECKSUM.so \
	libxt_cluster.so \
	libxt_comment.so \
	libxt_cpu.so \
	libxt_dccp.so \
	libxt_ecn.so \
	libxt_esp.so \
	libxt_hashlimit.so \
	libxt_hashlimit.so \
	libxt_HMARK.so \
	libxt_IDLETIMER.so \
	libxt_ipvs.so \
	libxt_LED.so \
	libxt_nfacct.so \
	libxt_NFLOG.so \
	libxt_NFQUEUE.so \
	libxt_NOTRACK.so \
	libxt_osf.so \
	libxt_owner.so \
	libxt_rateest.so \
	libxt_RATEEST.so \
	libxt_rpfilter.so \
	libxt_sctp.so \
	libxt_socket.so \
	libxt_statistic.so \
	libxt_TCPOPTSTRIP.so \
	libxt_TEE.so \
	libxt_time.so \
	libxt_TPROXY.so \
	libxt_TRACE.so"

for f in $USR_LIB_FILES_TO_REMOVE_LIST; do
	rm -f ${abspath}/${MNT}/usr/lib/xtables/$f
done

$HOST_PREFIX-strip --strip-unneeded ${abspath}/${MNT}/usr/lib/xtables/*.so* ${abspath}/${MNT}/lib/libxtables*.so*

