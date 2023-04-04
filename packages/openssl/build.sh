#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

cd $FETCHEDDIR
if [ ! -f Makefile ]; then
	# find correct ssl_target in Configurations/10-main.conf
	case $PL_BUILD_ARCH in
	x86_64|native-x86_64)
		ssl_target=linux-x86_64
		;;
	x86|native-x86)
		ssl_target=linux-elf
		;;
	powerpc)
		ssl_target=linux-ppc
		;;
	ar7100|ramips)
		ssl_target=linux-mips32
		;;
	arm)
		ssl_target="linux-armv4 -march=armv7-a"
		;;
	arm64)
		ssl_target="linux-aarch64 -march=armv8-a"
		;;
	*)
		ssl_target=linux-generic32
		;;
	esac
	./Configure --prefix=/usr --cross-compile-prefix=$HOST_PREFIX- --libdir=lib no-engine no-tests shared $ssl_target || exit 1
fi

# libssl & libcrypto shared lib
make $MAKE_OPTS || exit 1

# install to $STAGING
make DESTDIR=$STAGING install_dev

