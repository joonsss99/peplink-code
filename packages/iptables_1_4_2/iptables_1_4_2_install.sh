#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cp -Rpf ${FETCHEDDIR}/build/* ${abspath}/${MNT}/

USR_LIB_FILES_TO_REMOVE_LIST="libip6* libipt_ah.so libipt_CLUSTERIP.so libipt_ECN.so libipt_MIRROR.so libipt_realm.so libipt_SAME.so libipt_unclean.so libxt_AUDIT.so libxt_CHECKSUM.so libxt_cluster.so libxt_comment.so libxt_cpu.so libxt_ecn.so libxt_esp.so libxt_hashlimit.so libxt_HMARK.so libxt_IDLETIMER.so libxt_ipvs.so libxt_LED.so libxt_LED.so libxt_nfacct.so libxt_NFLOG.so libxt_NFQUEUE.so libxt_NOTRACK.so libxt_osf.so libxt_owner.so libxt_policy.so libxt_rateest.so libxt_RATEEST.so libxt_rpfilter.so libxt_sctp.so libxt_socket.so libxt_statistic.so libxt_TCPOPTSTRIP.so libxt_TEE.so libxt_time.so libxt_TPROXY.so libxt_TRACE.so libxt_connbytes.so libxt_helper.so"

for f in $USR_LIB_FILES_TO_REMOVE_LIST; do
	rm -f ${abspath}/${MNT}/usr/lib/xtables/$f
done

$HOST_PREFIX-strip $abspath/$MNT/sbin/iptables*
$HOST_PREFIX-strip --strip-unneeded $abspath/$MNT/usr/lib/xtables/*.so $abspath/$MNT/lib/libxtables.so.0.0.0

