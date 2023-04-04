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
gen_initramfs="$KERNEL_SRC/usr/gen_initramfs.sh"
kdump_cpio=$abspath/images/kdump.cpio

cd kernel.kdump

echo -e "${TCOLOR_GREEN}Generating ${TCOLOR_YELLOW}kdump.cpio.gz${TCOLOR_NORMAL}..."
$gen_initramfs -u squash -g squash -o $kdump_cpio $abspath/$PACKAGESDIR/$PACKAGE/kdump_cpio_list $abspath/$KDUMP_ROOT_DIR || exit $?
gzip -f -9 $kdump_cpio || exit $?

echo -e "${TCOLOR_GREEN}Copying ${TCOLOR_YELLOW}kdump.cpio.gz${TCOLOR_NORMAL} to ${TCOLOR_YELLOW}$MNT/$KEXEC_DIR${TCOLOR_NORMAL}..."
cp ${kdump_cpio}.gz $abspath/$MNT/$KEXEC_DIR/
