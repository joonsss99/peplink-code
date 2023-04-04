#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

# clean all modelhw objs
for modelhw in $TARGET_OFFLOAD_SW_CFG_LIST; do
	make -C $FETCHEDDIR/build clobber OBJ=${modelhw}
done

[ -f $FETCHEDDIR/build/config.mk ] && rm -f $FETCHEDDIR/build/config.mk
[ -f $FETCHEDDIR/build/buildno ] && rm -f $FETCHEDDIR/build/buildno
[ -f $FETCHEDDIR/build/software-release ] && rm -f $FETCHEDDIR/build/software-release

exit 0
