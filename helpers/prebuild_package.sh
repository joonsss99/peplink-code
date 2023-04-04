#!/bin/sh

PACKAGE=$1

. ${HELPERS}/functions

THISPACKAGE=${PACKAGESDIR}/${PACKAGE}
. ${THISPACKAGE}/${PACKAGE}.conf

# do the action
if [ -n "${prebuild}" ]; then
    . ${prebuild} ${PACKAGE}
fi
