#!/bin/bash

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

SVN_REV=$oprofile_REV

common_fetch_svn_rev $PACKAGE $SVN_REV $FETCHDIR

