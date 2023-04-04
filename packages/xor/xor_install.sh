#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

mkdir -p ${abspath}/${MNT}/usr/local/ilink/bin
make -C ${FETCHEDDIR} install RAMDISK_ROOT=${abspath}/${MNT}/usr/local/ilink

