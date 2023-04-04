#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ "${HAS_CONTENTHUB_PACKAGES}" = "y" ]; then
	PYTHON_DESTDIR="${abspath}/tmp/contenthub_packages"
	PYTHON_SITES="balance_sdk" # put "django" here to package Django into Python
else
	PYTHON_DESTDIR="${abspath}/${MNT}"
	PYTHON_SITES=
fi
PYTHON_PREFIX=`sed -n -e "/^prefix=[ \t]*/ { s///; p; q }" "${FETCHEDDIR}/Makefile"` && [ -n "${PYTHON_PREFIX}" ] || exit $?
PYTHON_DEST_PREFIX_DIR="${PYTHON_DESTDIR}${PYTHON_PREFIX}"
PYTHON_VERSION_XY=`sed -n -e "/^VERSION=/ { s|^.*=[ \t]*||; p; q }" "${FETCHEDDIR}/Makefile"`
PYTHON_VERSION_XYZ=`sed -n -e "/^#define[ \t]*PY_VERSION[ \t]*\"/ { s///; s/\".*//; p; q }" "${FETCHEDDIR}/Include/patchlevel.h"`
[ -n "${PYTHON_VERSION_XY}" -a -n "${PYTHON_VERSION_XYZ}" ] || exit $?
#
# Sites/frameworks
#   Goes before make install, which compiles .py in site-packages
#
if [ -n "${PYTHON_SITES}" ]; then
	PYTHON_SITES_DIR="${PYTHON_DEST_PREFIX_DIR}/lib/python${PYTHON_VERSION_XY}/site-packages"
	mkdir -p "${PYTHON_SITES_DIR}" || exit $?
	for SITE in ${PYTHON_SITES}; do
		SITE_SRC_DIR="${abspath}/tmp/${SITE}"
		if [ ! -d "${SITE_SRC_DIR}" ]; then
			echo "Required framework ${SITE} not found"
			exit 1
		fi
		case ${SITE} in
		django)
			rm -rf "${PYTHON_SITES_DIR}/django"
			cp -dpR "${SITE_SRC_DIR}" "${PYTHON_SITES_DIR}/django"
			;;
		balance_sdk)
			rm -rf "${PYTHON_SITES_DIR}/peplink"
			cp -dpR "${SITE_SRC_DIR}/python2" "${PYTHON_SITES_DIR}/peplink" || exit $?
			;;
		*)
			echo Unsupported python framework \"${SITE}\"
			exit 1
			;;
		esac
	done
fi
#
# Install
#   The make options should be identical to that in python_build.sh, as
#     `make install` also depends on the sharedmods target (which may depend on
#     those un-built modules)
#   Always overwrite existing installation if any
#
make -C "${FETCHEDDIR}" ${MAKE_OPTS} \
	BLDSHARED="${HOST_PREFIX}-gcc -shared" \
	CROSS_COMPILE=${HOST_PREFIX}- \
	HOSTARCH=${HOST_PREFIX}-gcc BUILDARCH=`gcc -dumpmachine` \
	PYTHON_XCOMPILE_DEPENDENCIES_PREFIX=${abspath}/staging/usr \
	DESTDIR="${PYTHON_DESTDIR}" \
	install || exit $?
#
# Strip and trim
#   Remove also .a (installed by install->commoninstall->libainstall target)
#
${HOST_PREFIX}-strip --strip-all \
	${PYTHON_DEST_PREFIX_DIR}/bin/python${PYTHON_VERSION_XY} \
	${PYTHON_DEST_PREFIX_DIR}/lib/python*/lib-dynload/*.so || exit $?
rm -f ${PYTHON_DEST_PREFIX_DIR}/lib/python*/config/libpython*.a \
	${PYTHON_DEST_PREFIX_DIR}/lib/libpython*.a
#
# Create .cfg file for contenthub_packager
#
if [ "${HAS_CONTENTHUB_PACKAGES}" = "y" ]; then
	PYTHON_DEST_CFG="${PYTHON_DESTDIR}/python.cfg"
	cat > "${PYTHON_DEST_CFG}" << EOF
NAME="python"
FULLNAME="Python"
VERSION_NAME="${PYTHON_VERSION_XYZ}"
EXTENSIONS="${PYTHON_SITES}"
ENVIRONMENT="PYTHONHOME:<MOUNTPOINT>"
ENVIRONMENT="PYTHONPATH:<MOUNTPOINT>"
ENVIRONMENT="PATH:<MOUNTPOINT>/bin"
EOF
fi
