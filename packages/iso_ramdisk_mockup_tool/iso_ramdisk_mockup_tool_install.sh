#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

# prepare the magic block if this is vm
if [ ${HOST_MODE} = "vm" ]; then
	cp -rf ${abspath}/${MNT}/usr/local/manga/magic_block_file/magic_block.${BUILD_TARGET} ${abspath}/${MNT}/usr/local/manga/magic_block_file/magic_block
	cp -rf ${abspath}/${MNT}/usr/local/manga/vm_license/vm_license.${BUILD_TARGET} ${abspath}/${MNT}/usr/local/manga/vm_license/vm_license
fi
