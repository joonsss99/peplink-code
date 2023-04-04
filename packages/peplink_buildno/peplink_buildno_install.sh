#!/bin/sh

PACKAGE=$1

FETCHEDDIR=$FETCHDIR/$PACKAGE
. $PACKAGESDIR/common/common_functions

abspath=`pwd`

[ "$FW_BUILD_NUMBER" = "n" -o -f $abspath/plb.bno ] && exit 0

mkdir -p $FETCHEDDIR
if ! git init -q $FETCHEDDIR ; then
	echo_error "Error (git) initializing $FETCHEDDIR"
	exit 1
fi

ref="refs/meta/build-number"

cd $FETCHEDDIR
if ! run_gitcmd "git fetch --depth=20 $GIT_FETCH_URL/pepos/build/firmware $ref" ; then
	echo_error "Unable to fetch from firmware.git#$ref"
	exit 1
fi
git checkout -q FETCH_HEAD

if [ ! -f $BUILD_TARGET.bno ] ; then
	echo -e "Initializing build number tracking for $TCOLOR_GREEN$BUILD_TARGET$TCOLOR_NORMAL"
	build_num=4888
	echo "$build_num" > $BUILD_TARGET.bno
else
	build_num=$(cat $BUILD_TARGET.bno)
	build_num=$((build_num+1))
	echo -e "Build number updated to $TCOLOR_GREEN$build_num$TCOLOR_NORMAL"
	echo "$build_num" > $BUILD_TARGET.bno
fi

git add $BUILD_TARGET.bno
cp -f $BUILD_TARGET.bno $abspath/plb.bno

if ! git commit -m "Update build number to $build_num for $BUILD_TARGET" ; then
	echo_error "Unable to commit changes for firmware.git#$ref"
	exit 1
fi
if ! run_gitcmd "git push $GIT_PUSH_URL/pepos/build/firmware HEAD:$ref" ; then
	echo_error "Unable to push latest commit to firmware.git#$ref"
	exit 1
fi
