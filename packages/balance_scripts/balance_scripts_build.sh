#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}
web_cgi_dir=$BALANCE_WEB_DIR/src/cgi
web_cgi_file="extended_dhcp_option.c extended_dhcp_option.h"

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

# this is not good to steal code files but yet to be reviewed
for fil in $web_cgi_file; do
	if [ ! -f $web_cgi_dir/${fil} ]; then
		echo "File $web_cgi_dir/${fil} not found"
		exit 1
	fi
	echo "cp -f $web_cgi_dir/${fil} ${FETCHEDDIR}/src"
	cp -f $web_cgi_dir/${fil} ${FETCHEDDIR}/src
done

case $PL_BUILD_ARCH in
x86|x86_64|ar7100|powerpc|arm|arm64|ramips)
	makeflag=""
	;;
*)
	echo_error "arch $PL_BUILD_ARCH not supported"
	exit 1
	;;
esac

make -f $abspath/$FETCHEDDIR/balance_interface/check.mk -C $FETCHEDDIR/balance_interface || exit $?

fmk="-f $PROJECT_MAKE/Makefile"
make $fmk -C $FETCHEDDIR empty_defconfig
make $fmk -C $FETCHEDDIR ${TARGET_SERIES}_defconfig
make $fmk -C $FETCHEDDIR ${BUILD_TARGET}_defconfig
make $fmk -C $FETCHEDDIR \
	CROSS_COMPILE=$HOST_PREFIX- \
	$makeflag $MAKE_OPTS || exit $?

