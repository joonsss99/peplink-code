#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

DEST_DIR=tmp

rm -rf "${DEST_DIR}/django"
mkdir -p "${DEST_DIR}"
cp -dpR "${FETCHEDDIR}/django" "${DEST_DIR}/"
