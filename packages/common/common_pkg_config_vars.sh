# Any package that uses `pkg-config` are suggested to source this script to
#   properly set those PKG_CONFIG* variables needed by `pkg-config`
#
# Note: Must set PKG_CONFIG_LIBDIR to prevent `pkg-config` from searching the
#   default search path (i.e. /usr/lib/pkgconfig) on the build machine
# See `man pkg-config` and its source code

export PKG_CONFIG=`which pkg-config`
export PKG_CONFIG_PATH=
export PKG_CONFIG_LIBDIR="$STAGING/lib/pkgconfig:$STAGING/staging/usr/local/lib/pkgconfig:$STAGING/usr/lib/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="$STAGING"
