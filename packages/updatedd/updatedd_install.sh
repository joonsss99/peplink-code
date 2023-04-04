#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ "${PL_BUILD_ARCH}" = "x86" -o "${PL_BUILD_ARCH}" = "x86_64" ]; then
BINTARGET=linux
elif [ "${PL_BUILD_ARCH}" = "ixp" ]; then
BINTARGET=ixp
else
BINTARGET=manga
fi

#make -C ${FETCHEDDIR} install

#Remove some OLD lib from unknown sourse
rm -f ${abspath}/${MNT}/lib/updatedd/*
rm -Rf ${abspath}/${MNT}/usr/local/lib/updatedd
rm -f ${abspath}/${MNT}/bin/updatedd
rm -f ${abspath}/${MNT}/usr/local/bin/updatedd

mkdir -p ${abspath}/${MNT}/lib/updatedd
mkdir -p ${abspath}/${MNT}/bin
mkdir -p ${abspath}/${MNT}/usr/local/ilink/bin

DDNS_LIST="libchangeip libdnsomatic libdyndns libnoip libothers"
for i in $DDNS_LIST; do
	cp -fP ${FETCHEDDIR}/updatedd-2.6/src/plugins/.libs/$i.so* ${abspath}/${MNT}/lib/updatedd/
done
cp -f ${FETCHEDDIR}/updatedd-2.6/src/updatedd ${abspath}/${MNT}/bin/
cp -f ${FETCHEDDIR}/wrapper/ddnsupdate ${abspath}/${MNT}/usr/local/ilink/bin/

