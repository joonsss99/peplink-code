#!/bin/sh

PACKAGE=$1

. $HELPERS/functions

THISPACKAGE=$PACKAGESDIR/$PACKAGE
. $THISPACKAGE/${PACKAGE}.conf

if [ -n "${hostbuild}" ]; then
	$hostbuild $PACKAGE
fi
