#!/bin/sh

PACKAGE=$1

abspath=`pwd`

install_dir="$abspath/$RAMFS_ROOT/usr/lib/hotplug/firmware"
mkdir -p $install_dir
cp -f $abspath/$PACKAGESDIR/$PACKAGE/vsc73*.bin $install_dir
