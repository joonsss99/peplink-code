#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR

#TODO:  LANNER_HWV2 and LANNER_HWV3 is for Balance 2500
#       add more options if we have another product require lan_bypass_utils
make CC=$HOST_PREFIX-gcc LANNER_HWV2=1 LANNER_HWV3=1

