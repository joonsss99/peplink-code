#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

BUILD=$FETCHEDDIR/build
mkdir -p $BUILD

abspath=`pwd`
fmk="-f $PROJECT_MAKE/Makefile"
make $fmk -C $FETCHEDDIR ${TARGET_SERIES}_defconfig || exit $?
# Install to firmware image
make $fmk -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$abspath/$MNT INSTALL_MODE=FWIMAGE install || exit $?
# Install to build directory
make $fmk -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$abspath/$BUILD INSTALL_MODE=UPGRADER install || exit $?
