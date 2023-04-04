#!/bin/sh
# public action

. ${HELPERS}/functions

PATH=$PATH:/sbin
RDISK=${TMP}/rdisk


echo "This script will create a ARM Linux RAMDISK"
SIZE=11264

dd if=/dev/zero of=${RDISK} bs=1k count=$SIZE
mke2fs -F ${RDISK}
mount -o loop -t ext2 ${RDISK} ${MNT}

. ${HELPERS}/prepare_fslayout
