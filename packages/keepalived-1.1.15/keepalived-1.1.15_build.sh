#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

CONFIGURE_OPTION="--disable-lvs --enable-vrrp"
GENERAL_OPTION="--host=$HOST_PREFIX --with-kernel-dir=$KERNEL_DIR"
CFLAGS="-I$STAGING/usr/include"
LDFLAGS="-L$STAGING/usr/lib -lstrutils -lstatus"

# Check if support libswitch
if [ "$BLD_CONFIG_LIBSWITCH" = "y" ]; then
	CFLAGS+=" -D_WITH_LIBSWITCH_"
	LDFLAGS+=" -lswitch -Wl,-rpath-link=$STAGING/usr/lib"
fi

# Execute the Configuration Script with Parameters
cd ${FETCHEDDIR} || exit $?
if [ ! -f Makefile ]; then
	#echo $EXEC_CMD
	#eval $EXEC_CMD
	CFLAGS=$CFLAGS LDFLAGS=$LDFLAGS \
		./configure $GENERAL_OPTION $CONFIGURE_OPTION || exit $?
fi

make $MAKE_OPTS || exit 1
