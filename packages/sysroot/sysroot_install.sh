#!/bin/sh

PACKAGE=$1

abspath=`pwd`

kdump_dir=$abspath/$KDUMP_ROOT_DIR
target_dirs="$abspath/$MNT"
upgrader_dir="$abspath/$UPGRADER_ROOT_DIR"

dirstruct=$abspath/$PACKAGESDIR/$PACKAGE/dirstruct_${ARCH_BITNESS}.txt

LIB_SRC_BASE=$BLD_CONFIG_SYSROOT/lib
echo "toolchain sysroot base: $LIB_SRC_BASE"

if [ "$FW_CONFIG_KDUMP" = "y" ]; then
	target_dirs="$target_dirs $kdump_dir"
fi

if [ "$HAS_UPGRADER" = "y" ]; then
	target_dirs="$target_dirs $upgrader_dir"
fi

for rd in $target_dirs ; do
	echo "In $rd:"
	mkdir -p $rd
	(cd $rd; $abspath/$PACKAGESDIR/$PACKAGE/dirparser.awk $dirstruct | xargs -0 sh -c) || exit $?

	(cd $LIB_SRC_BASE && tar -cf - lib*.so* ld*.so*) | tar -C $rd/lib -xf - || exit $?

	rm -f $rd/lib/libgo.* $rd/lib/*.py

	$HOST_PREFIX-strip $rd/lib/lib*.so*
	$HOST_PREFIX-strip $rd/lib/ld-*.so*
done

extra=$abspath/$PACKAGESDIR/$PACKAGE/dirstruct_extra.${BUILD_TARGET}
[ ! -f $extra ] || for rd in $target_dirs; do
	(cd $rd; $abspath/$PACKAGESDIR/$PACKAGE/dirparser.awk $extra | xargs -0 sh -c) || exit $?
done
