#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

common_flags="CROSS_COMPILE=$HOST_PREFIX-"

fmk="-f $PROJECT_MAKE/Makefile"

#WAR for hack coming from balance.profile !!!
if [ "${TARGET_SERIES}" = "pwmdcs" -a "${PL_BUILD_ARCH}" = "ramips" ]; then
	make $fmk -C $FETCHEDDIR ramips_defconfig 2> /dev/null
else
	make $fmk -C $FETCHEDDIR ${TARGET_SERIES}_defconfig 2> /dev/null
fi
make $fmk -C $FETCHEDDIR $common_flags $MAKE_OPTS || exit $?

case ${PL_BUILD_ARCH} in
x86*)
	make $fmk -C $FETCHEDDIR $common_flags CONFIG_X86_GENERIC_SETHWINFO=y sethwinfo || exit $?
	;;
esac

make $fmk -C $FETCHEDDIR $common_flags PREFIX=$STAGING/usr install-dev || exit $?
