#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
echo $abspath

# Do not install balance_ap_extender if BLD_CONFIG_WLC != y
[ "${BLD_CONFIG_WLC}" != "y" ] && exit 0

cp -rpf ${FETCHEDDIR}/build/etc/* ${abspath}/${MNT}/etc
cp -rpf ${FETCHEDDIR}/build/usr/* ${abspath}/${MNT}/usr
cp -rpf ${FETCHEDDIR}/build/var/* ${abspath}/${MNT}/var
cp -rpf ${FETCHEDDIR}/build/web_extap ${abspath}/${MNT}
