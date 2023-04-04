#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

# clean hostapd
make -C ${FETCHEDDIR}/hostapd clean

# clean wpa-supplicant
make -C ${FETCHEDDIR}/wpa_supplicant clean
