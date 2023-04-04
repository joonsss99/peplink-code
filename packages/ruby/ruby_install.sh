#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

#
# install
#
RUBY_PFX="${abspath}/tools/host/ruby"
RUBY_EXE="${RUBY_PFX}/usr/local/bin/ruby"
RUBY_VERSION_XY=`${RUBY_EXE} --disable-gems --version | sed -n -e 's|^ruby \([0-9]*\.[0-9]*\).*|\1|; p; q'`
RUBY_LIB_VERSION="${RUBY_VERSION_XY}.0"
RUBYLIB="${RUBY_PFX}/usr/local/lib/ruby/${RUBY_LIB_VERSION}"
RUBYLIB="${RUBYLIB}:${RUBY_PFX}/usr/local/lib/ruby/${RUBY_LIB_VERSION}/x86_64-linux"
make -C ${FETCHEDDIR} install DESTDIR=${abspath}/tmp/contenthub_packages RUBYLIB=${RUBYLIB} || exit $?
#
# Create .cfg file for contenthub_packager
#
CHUB_PKGS_DIR="${abspath}/tmp/contenthub_packages"
RUBY_DEST_CFG="${CHUB_PKGS_DIR}/ruby.cfg"
get_num()
{
	local file="$1" tag="$2"
	sed -n -e "/#[ ]*define[ ]*${tag}[ ]*\([0-9]\{1,\}\)\$/ { s||\1|; p; q }" "$file"
}
# fetch version from version.h
# Note: $ruby_version in Makefile may be referring to something else
#       (Ruby API version?).  Just don't use it
RUBY_VER_H="$FETCHEDDIR/version.h"
RUBY_API_VER_H="$FETCHEDDIR/include/ruby/version.h"
RUBY_VER_MAJOR=`get_num "$RUBY_VER_H" "RUBY_VERSION_MAJOR"`
RUBY_VER_MINOR=`get_num "$RUBY_VER_H" "RUBY_VERSION_MINOR"`
RUBY_VER_TEENY=`get_num "$RUBY_VER_H" "RUBY_VERSION_TEENY"`
# fetch version from include/ruby/version.h for API version otherwise
[ -n "$RUBY_VER_MAJOR" ] \
	|| RUBY_VER_MAJOR=`get_num "$RUBY_API_VER_H" "RUBY_API_VERSION_MAJOR"`
[ -n "$RUBY_VER_MINOR" ] \
	|| RUBY_VER_MINOR=`get_num "$RUBY_API_VER_H" "RUBY_API_VERSION_MINOR"`
[ -n "$RUBY_VER_TEENY" ] \
	|| RUBY_VER_TEENY=`get_num "$RUBY_API_VER_H" "RUBY_API_VERSION_TEENY"`
if [ -z "$RUBY_VER_MAJOR" -o -z "$RUBY_VER_MINOR" -o -z "$RUBY_VER_TEENY" ]; then
	echo "Failed getting Ruby version" >&2
	exit 1
fi
RUBY_VERSION_XYZ="${RUBY_VER_MAJOR}.${RUBY_VER_MINOR}.${RUBY_VER_TEENY}"
cat > "${RUBY_DEST_CFG}" << EOF
NAME="ruby"
FULLNAME="Ruby"
VERSION_NAME="${RUBY_VERSION_XYZ}"
ENVIRONMENT="PATH:<MOUNTPOINT>/bin"
ENVIRONMENT="RUBYLIB:<MOUNTPOINT>/lib/node_modules"
EOF
