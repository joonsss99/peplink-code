#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
lora_platform=pepos
lora_variant=std

make -C ${FETCHEDDIR} platform=$lora_platform variant=$lora_variant super-clean
rm -f ${FETCHEDDIR}/setup-$lora_platform.gmk
