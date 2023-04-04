#!/bin/sh
set -x

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

GOBI_HELPER_ABSPATH="${abspath}/${FETCHEDDIR}"

if [ ! -d ${abspath}/${FETCHEDDIR}/build ]; then
	echo_error "${abspath}/${FETCHEDDIR}/build does not exist!"
	exit 1
fi

DESTDIR=${abspath}/${MNT}

mkdir -p ${DESTDIR}
cp -Rpf ${GOBI_HELPER_ABSPATH}/build/* ${DESTDIR}/ || exit 1

inittab_install $abspath add respawn "/usr/local/ilink/bin/start_gobimon"
