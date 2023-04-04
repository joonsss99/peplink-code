#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}
abspath=`pwd`

if [ -e ${FETCHEDDIR}/ipt_NETFLOW.ko -a ${FETCHEDDIR}/libipt_NETFLOW.so ]; then
        make -C ${FETCHEDDIR} DESTDIR=${abspath}/${MNT} CROSS_COMPILE=$HOST_PREFIX- \
                IPTABLES_MODULES=/usr/lib/xtables install || exit $?
	${HOST_PREFIX}-strip ${abspath}/${MNT}/usr/lib/snmp/dlmod/snmp_NETFLOW.so
fi
