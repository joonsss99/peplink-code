#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
if [ "${abspath}/${MNT}" != "/" ] && [ -d ${abspath}/${MNT}/usr/local/ilink ]; then
rm -rf ${abspath}/${MNT}/*
fi
if [ ! -d  ${abspath}/${MNT} ]; then
(mkdir -p f ${abspath}/${MNT})
fi
