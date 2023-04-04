#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

STRONGSWAN_ABSPATH="${abspath}/${FETCHEDDIR}"

if [ ! -d $STRONGSWAN_ABSPATH/build ]; then
	echo_error "$STRONGSWAN_ABSPATH/build does not exist!"
	exit 1
fi

# Remove useless files
RM_LIST="share usr/lib/ipsec/*.la usr/libexec/ipsec/_copyright"
for i in $RM_LIST; do
	rm -rf $STRONGSWAN_ABSPATH/build/${i}
done

((cd $STRONGSWAN_ABSPATH/build/ && tar -cf - .) | (cd ${abspath}/tmp/mnt/ && tar --keep-directory-symlink -xpf -)) || exit 1

STRIP_LIST="
usr/libexec/ipsec/charon
usr/libexec/ipsec/starter
usr/libexec/ipsec/stroke
usr/libexec/ipsec/xfrmi
usr/lib/ipsec/libcharon.so.0.0.0
usr/lib/ipsec/libstrongswan.so.0.0.0"
for i in $STRIP_LIST; do
	${HOST_PREFIX}-strip -s ${abspath}/tmp/mnt/${i}
done
