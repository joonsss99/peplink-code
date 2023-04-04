#!/bin/sh

PACKAGE=$1

abspath=`pwd`

# RAMFS_ROOT wasn't create until a later stage, but kernel build 
# requires the directory for the init ramdisk during build
if [ "$BLD_CONFIG_USE_RAMFS" = "y" ] ; then
	mkdir -p $abspath/$RAMFS_ROOT
	# bug 4503. we need to have a dummy file in this directory
	# so during make kernel-build the kernel makefile
	# can generate the proper usr/.initramfs_data.cpio.gz.d
	touch $abspath/$RAMFS_ROOT/.dummy
fi
