#!/bin/bash

PACKAGE=$1

. $PACKAGESDIR/common/common_functions

set_pkgrev $PACKAGE

common_fetch_git $PACKAGE $pkgrev $FETCHDIR
