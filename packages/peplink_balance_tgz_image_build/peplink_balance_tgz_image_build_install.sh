#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

dst_path=${abspath}/images

SIZE=65536
if [ "$SIZE" = "" ]; then
	SIZE=12288
	echo_error "Cannot get ramdisk size from kernel source, using default = ${SIZE}kB"
fi

rootdir=$abspath/$MNT
rdisk=$dst_path/rootdisk.tar
rdisk_mnt=$dst_path/rdisk_mnt
rdisk_gz=$rdisk.gz

echo -e "${TCOLOR_BGREEN}Creating tar.gz image in ${TCOLOR_BYELLOW}$rdisk_gz ${TCOLOR_NORMAL}"
(cd $rootdir; mkdir -p .zzz; touch .zzz/zzz; export PATH="$HOST_TOOL_DIR/bin:$PATH"; $FAKEROOT_CMD tar -zcf $rdisk_gz --owner root --group root * .zzz/zzz)
[ $? -ne 0 ] && exit 1

if [ -f $rdisk_gz ]; then
	echo -e "${TCOLOR_BGREEN}Done: ${TCOLOR_BYELLOW}$rdisk_gz${TCOLOR_NORMAL}"
else
	echo_error "Compress failed"
	exit 1
fi

echo -e "${TCOLOR_BGREEN}Creating symlinks: ${TCOLOR_NORMAL}"
ln -sf $rdisk_gz $dst_path/rdisk.gz
echo -e " ${TCOLOR_BYELLOW}rdisk.gz ${TCOLOR_BGREEN}-> ${TCOLOR_BYELLOW}$rdisk_gz ${TCOLOR_NORMAL}"

