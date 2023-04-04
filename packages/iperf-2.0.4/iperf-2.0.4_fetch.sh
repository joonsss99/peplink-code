#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

CVS_TAG=${iperf_2_0_4_RTAG}

common_fetch_cvs_version ${PACKAGE} ${PACKAGE} ${CVS_TAG} ${FETCHDIR}

