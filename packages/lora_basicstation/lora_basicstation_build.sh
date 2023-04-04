#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
lora_platform=pepos
lora_variant=std

cd $FETCHEDDIR || exit $?

if [ ! -f setup-${lora_platform}.gmk ]; then
	echo "Creating "$(pwd)"/setup-${lora_platform}.gmk"
	cat > setup-${lora_platform}.gmk << GENERATE_TARGET_GMK_EOL
ARCH.$lora_platform = $HOST_PREFIX
TOOLCHAIN = $TOOLCHAIN_BASE_PATH/$TOOLCHAIN_VERSION/$HOST_PREFIX
CFG.$lora_platform = linux lgw1 no_leds sx1302 sx1302_v201
DEPS.$lora_platform = mbedtls lgw1302
LIBS.$lora_platform = -llgw1302  -lmbedtls -lmbedx509 -lmbedcrypto -lpthread -lrt
LGWVERSION.$lora_platform = 2.0.1
CFLAGS.$lora_platform = -DPEPLINK_LORAWAN_STATUS -DPEPLINK_LORAWAN_SYSLOG
GENERATE_TARGET_GMK_EOL
fi

make -j1 EXTRA_CFLAGS="-DPISMO_FLEXMODULE_LORA -DNODEBUG" \
	platform=$lora_platform  \
	variant=$lora_variant || exit $?
