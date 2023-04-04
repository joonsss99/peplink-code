#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

tools="usr/bin/opcontrol usr/bin/ophelp usr/bin/opreport usr/bin/oprofiled"

case $PL_BUILD_ARCH in
ar7100)
	tools="$tools usr/share/oprofile/mips/24K"
	;;
ixp)
	tools="$tools usr/share/oprofile/arm/xscale2"
	;;
x86)
	tools="$tools usr/share/oprofile/i386"
	;;
*)
	echo "Target: $PL_BUILD_ARCH not yet supported"
	exit 1
	;;
esac

for t in $tools ; do
	mkdir -p `dirname $abspath/$MNT/$t`
	cp -pPR $STAGING/$t $abspath/$MNT/$t || exit $?
done

