#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

tzsrc=$FETCHEDDIR/pepos-tz

if [ ! -f $tzsrc/Asia/Hong_Kong ]; then
	echo_error "zoneinfo not built correctly?"
	exit 1
fi

# Removed the existing zoneinfo (probably from ramdisk base)
rm -rf ${abspath}/${MNT}/usr/share/zoneinfo

tzlist="`$BALANCE_WEB_DIR/libtimezone/pepos-tz-list`"

mkdir -p ${abspath}/${MNT}/usr/share/zoneinfo

cd ${tzsrc}
for i in ${tzlist} ; do
	tar cf - $i | ( cd ${abspath}/${MNT}/usr/share/zoneinfo ; tar xf - ) || exit 1
done

cd ${abspath}

helpers/tzcheck.sh ${abspath}/${MNT}/usr/share/zoneinfo || exit 1

DESTDIR=${abspath}/${MNT}/usr/sbin
mkdir -p ${DESTDIR}
cp -f ${FETCHEDDIR}/zic ${DESTDIR}/ || exit 1
$HOST_PREFIX-strip ${DESTDIR}/zic
