#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd ${FETCHEDDIR} || exit $?
if [ ! -f Makefile ]; then
        if [ "$BLD_CONFIG_RESIZE_FS" != "y" ]; then
                FS_EXTRA_CONF_OPT="--disable-resizer"
        fi
	CFLAGS="-fPIC -O2" \
	./configure --host=$HOST_PREFIX \
		--disable-imager \
		--disable-defrag \
		--disable-debugfs \
		--disable-nls \
		${FS_EXTRA_CONF_OPT} \
		|| exit $?
fi

make libs progs $MAKE_OPTS || exit $?
make -C lib/uuid install DESTDIR=${STAGING} || exit $?
make -C lib/blkid install DESTDIR=$STAGING || exit $?
