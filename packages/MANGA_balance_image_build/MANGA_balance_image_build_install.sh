#!/bin/sh

# script to create ext2fs rootdisk image (with optional image encoding for x86)

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

HOST_TOOLS_DIR=$abspath/tools/host/bin
GENEXT2FS=$HOST_TOOLS_DIR/genext2fs

dst_path=${abspath}/images

SIZE=$(cat $KERNEL_OBJ/.config | grep CONFIG_BLK_DEV_RAM_SIZE | cut -d'=' -f2)
if [ "$SIZE" = "" ]; then
	SIZE=12288
	echo_error "Cannot get ramdisk size from kernel source, using default = ${SIZE}kB"
fi

if [ `du -sk $abspath/$MNT | cut -f 1` -gt $SIZE ]; then
	echo_error "Rootdisk size ($(du -sk $abspath/$MNT | cut -f 1)) is larger then configured size $SIZE"
	echo_error "You might need to reconfigure kernel's CONFIG_BLK_DEV_RAM_SIZE"
fi

rootdir=$abspath/$MNT
rdisk=$dst_path/rdisk.e2fs
rdisk_mnt=$dst_path/rdisk_mnt
rdisk_crypt=$dst_path/rdisk.crypted
ramdiskencode=$KERNEL_OBJ/usr/ramdiskencode

echo -e "${TCOLOR_BGREEN}Creating ramdisk image in ${TCOLOR_BYELLOW}$rdisk ${TCOLOR_BGREEN}size ${TCOLOR_BYELLOW}${SIZE}kB${TCOLOR_NORMAL}"

#echo "$GENEXT2FS -b $SIZE --root $rootdir --squash-uids --devtable $PACKAGESDIR/$PACKAGE/dev_table $rdisk"
if ! $GENEXT2FS -b $SIZE --root $rootdir --squash-uids --devtable $PACKAGESDIR/$PACKAGE/dev_table $rdisk ; then
	echo_error "failed to create ramdisk image."
	exit 1
fi

if grep '^CONFIG_RD_XZ=y' $KERNEL_OBJ/.config >/dev/null 2>&1; then
	rd_comp=xz
	rdisk_gz=$rdisk.xz
elif grep '^CONFIG_RD_GZIP=y' $KERNEL_OBJ/.config >/dev/null 2>&1; then
	rd_comp=gzip
	rdisk_gz=$rdisk.gz
else
	rd_comp=none
fi

# compress rdisk
echo -e "${TCOLOR_GREEN}Compressing ${TCOLOR_YELLOW}$rdisk${TCOLOR_GREEN} using ${TCOLOR_YELLOW}$rd_comp${TCOLOR_NORMAL}"
case $rd_comp in
xz)
	# --check=crc32 must be used for kernel to decompress
	xz --check=crc32 -f -T0 $rdisk
	;;
gzip)
	if which pigz >/dev/null 2>&1; then
		pigz -f9 $rdisk
	else
		gzip -f9 $rdisk
	fi
	;;
none|*)
	echo_error "No rootdisk compression method supported by kernel"
	exit 1
	;;
esac

if [ -f $rdisk_gz ]; then
	echo -e "${TCOLOR_BGREEN}Done: ${TCOLOR_BYELLOW}$rdisk_gz${TCOLOR_NORMAL}"
else
	echo_error "Compress failed"
	exit 1
fi

echo -e "${TCOLOR_BGREEN}Creating symlinks: ${TCOLOR_NORMAL}"
ln -sf $rdisk_gz $dst_path/rdisk.gz
echo -e " ${TCOLOR_BYELLOW}rdisk.gz ${TCOLOR_BGREEN}-> ${TCOLOR_BYELLOW}$(basename $rdisk_gz)${TCOLOR_NORMAL}"
