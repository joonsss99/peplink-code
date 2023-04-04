#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd "$FETCHEDDIR" || exit $?

case $BUILD_TARGET in
m700|*maxotg)
       OPTION="-Os"
       ;;
*)
       OPTION="-O2"
       ;;
esac

if [ ! -f Makefile ] ; then
	./configure CFLAGS="$OPTION -I$STAGING/usr/include \
		-DSQLITE_MAX_ATTACHED=32 -DSQLITE_OMIT_VIRTUALTABLE \
		-DSQLITE_OMIT_COMPILEOPTION_DIAGS -DSQLITE_OMIT_WINDOWFUNC \
		-DSQLITE_OMIT_DEPRECATED -DSQLITE_OMIT_EXPLAIN" \
		LDFLAGS="-L$STAGING/usr/lib -Wl,-rpath-link=$STAGING/usr/lib" \
		--prefix=/usr \
		--host=$HOST_PREFIX \
		--enable-threadsafe \
		--enable-fts3 \
		--enable-rtree \
		--disable-math \
		--disable-load-extension \
		--disable-static \
		--disable-tcl || exit $?
fi

make $MAKE_OPTS || exit $?
make $MAKE_OPTS DESTDIR=$STAGING install || exit $?
rm -f $STAGING/usr/lib/libsqlite*.la || exit $?
