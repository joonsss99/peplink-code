#!/bin/sh

PACKAGE=$1

FETCHEDDIR=$KERNEL_SRC

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

makeflag="ARCH=$KERNEL_ARCH CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS"

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	makeflag="$makeflag O=$KERNEL_OBJ"
fi

if [ "$BLD_CONFIG_USE_RAMFS" = "y" ] ; then
	makeflag="$makeflag RAMFS_DIR=$abspath/$RAMFS_ROOT"
fi

echo -e "${TCOLOR_BGREEN}building linux kernel...${TCOLOR_NORMAL}"
if [ ! -f $KERNEL_OBJ/.config ]; then
	echo "${PACKAGE}: .config file is missing"
	exit 1
fi
make -C ${FETCHEDDIR} $makeflag oldconfig || exit $?
make -C ${FETCHEDDIR} $makeflag all || exit $?
make -C $FETCHEDDIR $makeflag headers_install INSTALL_HDR_PATH=$STAGING/khdrs || exit $?

kheaders_rsync $STAGING/khdrs/ $STAGING/khdrs-1/ $KERNEL_HEADERS

# for mips platform that does not need RAMFS image embedded to kernel image
# we can build vmlinux.bin at this stage.
if [ "$KERNEL_ARCH" = "mips" ] && [ "$BLD_CONFIG_USE_RAMFS" != "y" ] ; then
	make -C $FETCHEDDIR $makeflag $KIMAGE_NAME || exit $?
	# we need this to have Modules.symvers properly generated (include modules
	# EXPORT_SYMBOLS
	make -C $FETCHEDDIR $makeflag modules
fi

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	echo -e "${TCOLOR_BGREEN}building kdump kernel...${TCOLOR_NORMAL}"
	make -C $FETCHEDDIR ARCH=$KERNEL_ARCH CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS O=$PWD/kernel.kdump all || exit $?

	dmesg_inc=$KERNEL_OBJ/vmlinux_dmesg.inc
	# below symbol dumps is explicitly for kernel before version 3.5
	addr=`$HOST_PREFIX-objdump -t $KERNEL_OBJ/vmlinux | grep "\Wlog_buf$" | cut -d ' ' -f 1`
	echo "static loff_t log_buf_vaddr = 0x$addr;" > $dmesg_inc
	addr=`$HOST_PREFIX-objdump -t $KERNEL_OBJ/vmlinux | grep "\Wlog_end$" | cut -d ' ' -f 1`
	echo "static loff_t log_end_vaddr = 0x$addr;" >> $dmesg_inc
	addr=`$HOST_PREFIX-objdump -t $KERNEL_OBJ/vmlinux | grep "\Wlog_buf_len$" | cut -d ' ' -f 1`
	echo "static loff_t log_buf_len_vaddr = 0x$addr;" >> $dmesg_inc
	addr=`$HOST_PREFIX-objdump -t $KERNEL_OBJ/vmlinux | grep "\Wlogged_chars$" | cut -d ' ' -f 1`
	echo "static loff_t logged_chars_vaddr = 0x$addr;" >> $dmesg_inc

	# these are not defined in old kernel, but needed inorder to compile
	echo "static loff_t log_first_idx_vaddr;" >> $dmesg_inc
	echo "static loff_t log_next_idx_vaddr;" >> $dmesg_inc
	echo "static uint64_t log_sz;" >> $dmesg_inc
	echo "static uint64_t log_offset_ts_nsec = UINT64_MAX;" >> $dmesg_inc
	echo "static uint16_t log_offset_len = UINT16_MAX;" >> $dmesg_inc
	echo "static uint16_t log_offset_text_len = UINT16_MAX;" >> $dmesg_inc
fi

