#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

IPTABLES_VER=`sed -n -e 's/^VERSION[ ]*=[ ]*\([0-9.]\{5,\}\)$/\1/p' \
	${IPTABLES_PATH}/Makefile` || exit $?

. ./make.conf

cd $FETCHEDDIR || exit $?

if [ ! -f Makefile ]; then
	config_options="--ipt-inc=${STAGING}/usr/include \
			--ipt-lib=${STAGING}/usr/lib/xtables \
			--usr-lib=${STAGING}/usr/lib/ \
			--ipt-ver=${IPTABLES_VER} \
			--ipt-src=${IPTABLES_PATH} \
			--kdir=${KERNEL_SRC} --kobj=${KERNEL_OBJ} \
			--enable-macaddress --enable-direction --enable-aggregation \
			--disable-dkms --disable-dkms-install --no-ipv6"

	if [ "$BLD_CONFIG_KERNEL_V2_6_28" == "y" ] ; then
		# We need to disable Netflow SNMP MIB support due to firmware
		# size limitation on linux 2.6 based models.
		config_options+=" --disable-net-snmp"
	else
		config_options+=" --enable-snmp-rules"
	fi
	./configure $config_options || exit $?
fi

make ARCH=$KERNEL_ARCH CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$STAGING $MAKE_OPTS || exit $?
