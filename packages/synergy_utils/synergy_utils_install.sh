#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

case ${BUILD_TARGET} in
apx|balance2500|ipq|ipq64|maxhd4|mtk5g|ramips)
	echo -n "controller-device" > $abspath/$MNT/etc/synergy-avail
	;;
m700|maxbr1ac|maxotg)
	echo -n "device" > $abspath/$MNT/etc/synergy-avail
	;;
*)
	exit 0
	;;
esac

make -f $PROJECT_MAKE/Makefile -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- \
	install DESTDIR=$abspath/$MNT PREFIX=/usr/local/ilink || exit $?
