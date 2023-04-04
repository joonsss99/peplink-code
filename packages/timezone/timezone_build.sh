#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

# build "zic" which helps to build zone data (host build)
make -C $FETCHEDDIR clean || exit $?
make -C $FETCHEDDIR zic $MAKE_OPTS || exit $?

# build timezone data

cd $FETCHEDDIR
[ -x zic ] || exit 1
rm -rf pepos-tz
mkdir pepos-tz

zonedata="africa antarctica asia australasia etcetera europe northamerica southamerica"

echo "Building timezone files in pepos-tz/"

# TIMEZONE_OLD_GLIBC_COMPAT exported in profiles/balance.profile
if [ x"$TIMEZONE_OLD_GLIBC_COMPAT" = xy ] ; then
	FAT_OPTION="-b fat"
fi
./zic $FAT_OPTION -d pepos-tz $zonedata || exit $?

# build target specific zic binary
cd $abspath
make -C $FETCHEDDIR clean || exit $?
make -C $FETCHEDDIR zic CC=$HOST_PREFIX-gcc CFLAGS=-O2 $MAKE_OPTS || exit $?
