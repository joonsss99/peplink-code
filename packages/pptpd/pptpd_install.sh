#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

mkdir -p ${abspath}/${MNT}/usr/sbin

cp -Rpf ${FETCHEDDIR}/pptpd ${abspath}/${MNT}/usr/sbin/ || exit 1
cp -Rpf ${FETCHEDDIR}/pptpctrl ${abspath}/${MNT}/usr/sbin/ || exit 1

${HOST_PREFIX}-strip ${abspath}/${MNT}/usr/sbin/pptpd || exit 1
${HOST_PREFIX}-strip ${abspath}/${MNT}/usr/sbin/pptpctrl || exit 1

exit 0

