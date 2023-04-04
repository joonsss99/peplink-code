#!/bin/bash

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

set_pkgrev $PACKAGE

common_fetch_svn_rev $PACKAGE $pkgrev $FETCHDIR

