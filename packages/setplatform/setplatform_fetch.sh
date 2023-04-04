#!/bin/bash

abspath=`pwd`

if [ -f $abspath/.last_build_model ]; then
	LAST_BUILD=`cat $abspath/.last_build_model`
	if [ "$BUILD_TARGET" != "$LAST_BUILD" ]; then
		echo "Build target changed from ${LAST_BUILD} to ${BUILD_TARGET}"
		echo "You must do a make clean"
		echo "or re-checkout the project to make"
		exit 1
	fi
fi

echo "${BUILD_TARGET}" > $abspath/.last_build_model

if [ ! -d ${abspath}/${MNT} ]; then
	mkdir -p  ${abspath}/${MNT}
fi

if [ ! -d ${abspath}/images ]; then
	mkdir -p  ${abspath}/images
fi

if [ ! -d ${FETCHDIR} ]; then
	mkdir -p ${FETCHDIR}
fi

