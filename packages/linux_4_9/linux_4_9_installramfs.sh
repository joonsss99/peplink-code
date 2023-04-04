#!/bin/sh

FETCHEDDIR=$KERNEL_SRC

# shellcheck source=/dev/null
. ./make.conf
# shellcheck source=/dev/null
. "${PACKAGESDIR}"/common/common_functions

abspath=$(pwd)

makeflag="ARCH=$KERNEL_ARCH CROSS_COMPILE=$HOST_PREFIX- \
$MAKE_OPTS DEPMOD=$HOST_TOOL_DEPMOD"

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	makeflag="$makeflag O=$KERNEL_OBJ"
fi

make -C "${FETCHEDDIR}" $makeflag \
INSTALL_MOD_PATH="${abspath}"/"${RAMFS_ROOT}" INSTALL_MOD_STRIP=1 modules_install

KERNEL_RELEASE=$(MAKEFLAGS="" make -s --no-print-directory -C "${FETCHEDDIR}" $makeflag kernelrelease)

# remove unneeded kernel modules to save space
files='build
source
kernel
'

for f in $files ; do
	rm -rf "$abspath"/"$RAMFS_ROOT"/lib/modules/"${KERNEL_RELEASE}"/"$f"
done

$HOST_TOOL_DEPMOD -a -b "${abspath}"/"${RAMFS_ROOT}" "${KERNEL_RELEASE}"
