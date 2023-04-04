#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

base=$FETCHEDDIR/coco

case $BUILD_TARGET in
	maxbr1ac|maxdcs|aponeac)
		loader_platform=mips
		fips_coco_ssl_lib=$base/openssl/mips/opt/local/lib
		;;
	balance2500)
		loader_platform=x86_64_balance2500
		fips_coco_ssl_lib=$base/openssl/x86_64/opt/local/lib64
		;;
	fhvm)
		loader_platform=x86_64_fusionhub
		fips_coco_ssl_lib=$base/openssl/x86_64/opt/local/lib64
		;;
	maxhd4|maxdcs_ppc)
		loader_platform=powerpc
		fips_coco_ssl_lib=$base/openssl/ppc/opt/local/lib
		;;
esac

dest_base=/opt/fips-coco

#
# kmod
#

kmod_loader=$base/loader/$loader_platform/usr/bin/crypto_loader

# Coco's kernel module loader
mkdir -p $abspath/$MNT$dest_base/bin
cp $kmod_loader $abspath/$MNT$dest_base/bin/

# our own run time shim for coco's kernel module
mkdir -p $abspath/$MNT/usr/local/ilink/lib/
cp $FETCHEDDIR/pepos/fips_runtime.ko $abspath/$MNT/usr/local/ilink/lib/

#
# coco's openssl
#

libs="libssl libcrypto"
libapiver=1.0.0
libver=1.0.2i

mkdir -p $abspath/$MNT$dest_base/lib/

for l in $libs ; do

	# copy the actual binary libxxx.so.1.0.2x
	cp $fips_coco_ssl_lib/${l}.so.$libver $abspath/$MNT$dest_base/lib/ || exit $?
	chmod 755 $abspath/$MNT$dest_base/lib/${l}.so.$libver
	$HOST_PREFIX-strip $abspath/$MNT$dest_base/lib/${l}.so.$libver

	# libxxx.so.1.0.0 symlink
	rm -f $abspath/$MNT$dest_base/lib/${l}.so.$libapiver
	ln -s ${l}.so.$libver $abspath/$MNT$dest_base/lib/${l}.so.$libapiver

	# libxxx.so symlink
	rm -f $abspath/$MNT$dest_base/lib/${l}.so
	ln -s ${l}.so.$libapiver $abspath/$MNT$dest_base/lib/${l}.so
done
