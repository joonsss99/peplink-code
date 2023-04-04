#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

TIMEBOMB_BIN=${abspath}/${MNT}/${TIMEBOMB_PATH}
mkdir -p $(dirname ${TIMEBOMB_BIN})

if [ x"$TIMEBOMB" = x"yes" ] ; then
	echo -n $TIMEBOMB_STAMP > ${TIMEBOMB_BIN}
else
	rm -f ${TIMEBOME_BIN}
fi

