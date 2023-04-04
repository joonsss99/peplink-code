#!/bin/sh

PACKAGE=$1

. ${HELPERS}/functions

THISPACKAGE=${PACKAGESDIR}/${PACKAGE}
. ${THISPACKAGE}/${PACKAGE}.conf

# do the action
if [ -n "${clean}" ]; then
    . ${clean} ${PACKAGE}
fi
