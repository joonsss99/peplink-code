#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}
ELTORITO=${PACKAGESDIR}/${PACKAGE}/stage2_eltorito

. ${PACKAGESDIR}/common/common_functions
. ${PACKAGESDIR}/common/upgrader_functions

abspath=`pwd`

command -v genisoimage > /dev/null 2>&1 
if [ $? -ne 0 ]; then
	echo "command genisoimage is not found"
	exit;
fi

if [ "${PL_BUILD_ARCH}" != "x86" -a "${PL_BUILD_ARCH}" != "x86_64" ]; then
	echo "Not support this PL_BUILD_ARCH : ${PL_BUILD_ARCH}"
	exit
fi

abspath=`pwd`
dstpath=$abspath/images
isoroot=$dstpath/isoroot
isofile=$dstpath/file.iso
version=`cat $abspath/tmp/mnt/etc/software-release | cut -d 'v' -f 2`
BUILD_NUMBER=`cat plb.bno`

case $FWNAME_MODEL in
fusionhub)
	productname="FusionHub"
	;;
*)
	productname="Unknown"
	;;
esac

mkdir -p $isoroot/boot
mkdir -p $isoroot/boot/grub
cp -rf $dstpath/bzImage $isoroot/boot/data1
cp -rf $dstpath/rdisk.crypted $isoroot/boot/data2
cp -rf ${ELTORITO} $isoroot/boot/grub

cat > $isoroot/boot/grub/menu.lst << EOF
default 0
timeout 0
hiddenmenu

title $productname $version
kernel /boot/data1 root=/dev/ram0 quiet
initrd /boot/data2
EOF

genisoimage -R -b boot/grub/stage2_eltorito -input-hfs-charset utf8 --no-emul-boot -boot-load-size 4 -boot-info-table -o $isofile $isoroot
set_iso_filename $isofile
