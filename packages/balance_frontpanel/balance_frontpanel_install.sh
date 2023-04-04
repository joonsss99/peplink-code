#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

BINIMAGE=${FETCHEDDIR}/fp_main

[ ! -f ${BINIMAGE} ] && (echo "${PACKAGE}: binary file not found!") && (exit 1)

abspath=`pwd`

cp -pf ${BINIMAGE} ${abspath}/${MNT}/usr/local/ilink/bin/ || exit 1

inittab_install $abspath add respawn "/usr/local/ilink/bin/fp_main"
