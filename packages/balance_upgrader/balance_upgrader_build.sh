#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

if [ "$PL_BUILD_ARCH" = "ar7100" ]; then
	fmk="-f $PROJECT_MAKE/Makefile"
	make $fmk -C ${FETCHEDDIR}/checksum_generator empty_defconfig
	make $fmk -C ${FETCHEDDIR}/checksum_generator || exit $?
else
	case $BUILD_TARGET in
	maxdcs_ipq|ipq|apone|aponeac|aponeax|ipq64|mtk5g|ramips|maxdcs_ramips|sfchn)
		fmk="-f $PROJECT_MAKE/Makefile"
		make $fmk -C ${FETCHEDDIR}/checksum_generator empty_defconfig
		make $fmk -C ${FETCHEDDIR}/checksum_generator CROSS_COMPILE=$HOST_PREFIX- || exit $?
		;;
	esac
fi
