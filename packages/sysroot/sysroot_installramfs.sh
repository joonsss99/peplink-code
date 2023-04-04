#!/bin/sh

PACKAGE=$1

abspath=`pwd`

target_dirs="$abspath/$RAMFS_ROOT"

dirstruct=$abspath/$PACKAGESDIR/$PACKAGE/dirstruct_${ARCH_BITNESS}.txt

LIB_SRC_BASE=$BLD_CONFIG_SYSROOT/lib
echo "toolchain sysroot base: $LIB_SRC_BASE"

for rd in $target_dirs ; do
	mkdir -p $rd
	(cd $rd; $abspath/$PACKAGESDIR/$PACKAGE/dirparser.awk $dirstruct | xargs -0 sh -c) || exit $?

	(cd $LIB_SRC_BASE && tar -cf - lib*.so* ld*.so*) | tar -C $rd/lib -xf - || exit $?

	$HOST_PREFIX-strip $rd/lib/lib*.so*
	$HOST_PREFIX-strip $rd/lib/ld-*.so*

	# do not install libgo.so in ramfs
	rm -f $rd/lib/libgo.*
done
