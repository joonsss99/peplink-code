#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
lora_install_dir="$abspath/$MNT/usr/sbin/"
lora_platform=pepos
lora_variant=std

install -s --strip-program=$HOST_PREFIX-strip -D -t "$lora_install_dir" \
		$FETCHEDDIR/build-$lora_platform-$lora_variant/bin/station \
		|| exit $?
