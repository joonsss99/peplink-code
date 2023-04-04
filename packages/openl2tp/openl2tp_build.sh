#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

make -C ${FETCHEDDIR} STAGING=$STAGING L2TP_FEATURE_RPC_MANAGEMENT=n CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS l2tpd || exit $?
