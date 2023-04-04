#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

src_appname=nuttcp
dst_appname=nuttcp

dst_appdir=usr/bin

[ ! -f ${FETCHEDDIR}/$src_appname ] && echo "missing binary" && exit 1

mkdir -p ${abspath}/${MNT}/$dst_appdir

cp -Rpf ${FETCHEDDIR}/$src_appname ${abspath}/${MNT}/$dst_appdir/$dst_appname || exit $?

$HOST_PREFIX-strip ${abspath}/${MNT}/$dst_appdir/$dst_appname || exit $?

