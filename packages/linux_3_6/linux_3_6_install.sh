#!/bin/sh

PACKAGE=$1

FETCHEDDIR=$KERNEL_SRC

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

makeflag="ARCH=$KERNEL_ARCH CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS DEPMOD=$HOST_TOOL_DEPMOD"

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	makeflag="$makeflag O=$KERNEL_OBJ"
fi

make -C ${FETCHEDDIR} $makeflag INSTALL_MOD_PATH=${abspath}/${MNT} INSTALL_MOD_STRIP=1 modules_install

if [ "$BLD_CONFIG_USE_RAMFS" = "y" ]; then
	echo -e "${TCOLOR_BGREEN}Updating ramfs disk image to ${TCOLOR_BYELLOW}$KIMAGE_NAME${TCOLOR_NORMAL}..."

#we need to rebuild vmlinux.bin for ramfs system (to include latest ramfs root from installramfs)

	make -C ${FETCHEDDIR} $makeflag $KIMAGE_NAME || exit $?

	if [ ! -f  ${FETCHEDDIR}/usr/initramfs_data.o ]; then
#due to some reason, "make vmlinux.bin" not always include initramfs data
		make -C ${FETCHEDDIR} $makeflag $KIMAGE_NAME || exit $?
	fi

	# make sure proper Modules.symvers are generated.
	# the "vmlinux.bin" target will generate a Modules.symvers with only
	# kernel image's symbols
	make -C $FETCHEDDIR $makeflag modules
fi

dstpath=$abspath/images

echo -e "${TCOLOR_BGREEN}Copying kernel image (${TCOLOR_BYELLOW}${KIMAGE_NAME}${TCOLOR_BGREEN}) to ${TCOLOR_BYELLOW}$dstpath${TCOLOR_NORMAL}"
cp -f $KERNEL_OBJ/arch/$KERNEL_ARCH/boot/$KIMAGE_NAME $dstpath

#
# kdump
#
if [ "$FW_CONFIG_KDUMP" = "y" ] ; then
	mkdir -p $abspath/$MNT/$KEXEC_DIR
	cp -f $abspath/kernel.kdump/arch/$KERNEL_ARCH/boot/$KIMAGE_NAME  $abspath/$MNT/$KEXEC_DIR/${KIMAGE_NAME}.kdump
fi
