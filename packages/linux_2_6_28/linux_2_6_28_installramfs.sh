#!/bin/sh

PACKAGE=$1

FETCHEDDIR=$KERNEL_SRC

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

mkdir -p ${abspath}/${RAMFS_ROOT}/mnt/rd
mkdir -p ${abspath}/${RAMFS_ROOT}/mnt/sda1
make -C ${FETCHEDDIR} \
	ARCH=$KERNEL_ARCH CROSS_COMPILE=$HOST_PREFIX- \
	INSTALL_MOD_PATH=${abspath}/${RAMFS_ROOT} \
	INSTALL_MOD_STRIP=1 \
	DEPMOD=$HOST_TOOL_DEPMOD \
	$MAKE_OPTS \
	modules_install

# remove unneeded kernel modules to save space
files='lib/modules/2.6.28.10/kernel/drivers/cdrom/cdrom.ko
lib/modules/2.6.28.10/kernel/drivers/char/nozomi.ko
lib/modules/2.6.28.10/kernel/drivers/net/usb/*.ko
lib/modules/2.6.28.10/kernel/drivers/net/usb/gobiusbnet234/GobiNet234.ko
lib/modules/2.6.28.10/kernel/drivers/net/usb/gobiusbnet/GobiNet.ko
lib/modules/2.6.28.10/kernel/drivers/usb/serial/*.ko
lib/modules/2.6.28.10/kernel/net/bridge/netfilter/*
lib/modules/2.6.28.10/kernel/net/netfilter/xt_*.ko
lib/modules/2.6.28.10/kernel/net/ipv4/netfilter/ipt_*.ko
lib/modules/2.6.28.10/kernel/net/ipv6/*'

for f in $files ; do
	rm -f $abspath/$RAMFS_ROOT/$f
done
