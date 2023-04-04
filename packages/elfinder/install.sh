#!/bin/sh

set -e

PACKAGE="$1"
FETCHEDDIR="${FETCHDIR}/${PACKAGE}"
abspath=`pwd`

make -C "${FETCHEDDIR}" install DESTDIR="${abspath}/${MNT}" prefix="/web/filemanager"
