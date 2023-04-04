#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd ${FETCHEDDIR}/build;  tar -cf - * | tar -C $abspath/$MNT/ -xf -
cd ${abspath}

mkdir -p ${abspath}/${MNT}/etc/ppp/peers > /dev/null 2>&1


#
# DO NOT create these device. they should either be prepopulated by ramdisk or created at runtime.
#
#[ ! -f ${abspath}/${MNT}/dev/sda ] && (mknod ${abspath}/${MNT}/dev/sda b 8 0) > /dev/null 2>&1
#ii=0
#mkdir -p ${abspath}/${MNT}/dev/usb/tts
#while [ $ii -le 100 ]; do
#	mknod ${abspath}/${MNT}/dev/usb/tts/$ii c 188 $ii > /dev/null 2>&1
#	let ii=ii+1
#done
