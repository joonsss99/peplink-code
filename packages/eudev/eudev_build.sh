#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd ${FETCHEDDIR} || exit $?

if [ ! -f configure ]; then
	./autogen.sh || exit $?
fi

if [ ! -f Makefile ]; then
	# Skip some config tests
	rm -f eudev.cache
	echo ac_cv_lib_acl_acl_init=yes > eudev.cache

	CFLAGS="-I$STAGING/usr/include" \
	./configure \
		--host=$HOST_PREFIX \
		--cache-file=eudev.cache \
		--prefix="" \
		--disable-silent-rules \
		--enable-introspection=no \
		--disable-gtk-doc-html \
		--enable-static=no \
		--enable-shared=yes \
		--disable-gudev \
		--disable-manpages \
		--disable-selinux \
		--disable-blkid \
		--disable-largefile \
		--disable-keymap \
		--disable-modules \
		--disable-rule-generator \
		|| exit $?
fi

make $MAKE_OPTS || exit 1

echo "Build ${PACKAGE} done"
