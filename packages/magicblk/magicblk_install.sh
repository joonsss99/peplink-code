#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

fmk="-f $PROJECT_MAKE/Makefile"

if [ "$BUILD_TARGET" = "vbal" ]; then
	EXTRA_PARAM="CONFIG_X86_GENERIC_SETHWINFO=y"
fi

make $fmk -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$abspath/$MNT PREFIX=/ $EXTRA_PARAM install-exec || exit $?
make $fmk -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$abspath/$UPGRADER_ROOT_DIR PREFIX=/ install-exec || exit $?

# web still uses the versioned balance_unlock_code_XYZ in /usr/local/ilink/bin, so we symlink it
unlock_version=`grep CONFIG_BALANCE_UNLOCK_VERSION $abspath/$FETCHEDDIR/.config | cut -d '=' -f 2`
unlock_symlink=$abspath/$MNT/usr/local/ilink/bin/balance_unlock_code_$unlock_version
rm -f $unlock_symlink
mkdir -p $abspath/$MNT/usr/local/ilink/bin
ln -s /bin/balance_unlock_code $unlock_symlink
