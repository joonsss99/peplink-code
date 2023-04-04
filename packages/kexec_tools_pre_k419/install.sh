#!/bin/sh

PACKAGE=$1

FETCHEDDIR=$FETCHDIR/$PACKAGE

. $PACKAGESDIR/common/common_functions

abspath=`pwd`

if [ "$FW_CONFIG_KDUMP" != "y" ]; then
	echo "kdump not enabled, not installing."
	exit 0
fi

kdump_cpio_list="images/kdump_cpio_list"

cp -f $FETCHEDDIR/build/sbin/kexec $abspath/$MNT/usr/sbin/
$HOST_PREFIX-strip $abspath/$MNT/usr/sbin/kexec

cp -f $FETCHEDDIR/build/sbin/vmcore-dmesg $abspath/$KDUMP_ROOT_DIR/usr/sbin/
$HOST_PREFIX-strip $abspath/$KDUMP_ROOT_DIR/usr/sbin/vmcore-dmesg

# for kernel that no longer use gen_initramfs_list.sh
cp $PACKAGESDIR/$PACKAGE/kdump_cpio_list $kdump_cpio_list
sh $KERNEL_SRC/scripts/gen_initramfs_list.sh -u squash -g squash $abspath/$KDUMP_ROOT_DIR >> $kdump_cpio_list || exit 1

echo -e "${TCOLOR_BGREEN}Generating ${TCOLOR_BYELLOW}kdump.cpio.gz${TCOLOR_NORMAL}..."
kernel.kdump/usr/gen_init_cpio $kdump_cpio_list > images/kdump.cpio || exit 1
gzip -f -9 images/kdump.cpio

echo -e "${TCOLOR_BGREEN}Copying ${TCOLOR_BYELLOW}kdump.cpio.gz${TCOLOR_NORMAL} to ${TCOLOR_BYELLOW}$MNT/$KEXEC_DIR${TCOLOR_NORMAL}..."
cp images/kdump.cpio.gz $abspath/$MNT/$KEXEC_DIR/
