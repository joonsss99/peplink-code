#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

case $PL_BUILD_ARCH in
x86|x86_64)
	make -C ${FETCHEDDIR} X86=1 CC=$HOST_PREFIX-gcc || exit $?
	;;
ixp)
	make -C ${FETCHEDDIR} TNT=1 CC=$HOST_PREFIX-gcc || exit $?
	;;
ar7100)
	make -C ${FETCHEDDIR} PISMO501=1 CC=$HOST_PREFIX-gcc || exit $?
	;;
powerpc)
	make -C ${FETCHEDDIR} PISMO501=1 CC=$HOST_PREFIX-gcc || exit $?
	;;
arm|arm64|ramips)
	case $BUILD_TARGET in
	ipq|apone|aponeax|ipq64|mtk5g|ramips|sfchn)
		# temporary reuse PISMO501 option
		make -C ${FETCHEDDIR} PISMO501=1 CC=$HOST_PREFIX-gcc || exit $?
		;;
	*)
		echo_error "arch $PL_BUILD_ARCH target $BUILD_TARGET not supported"
		exit 1
		;;
	esac
	;;
*)
	echo_error "arch $PL_BUILD_ARCH not supported"
	exit 1
	;;
esac
