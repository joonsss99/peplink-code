#!/bin/sh

# [Bug#15462] ContentHub (tools) packaging

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

DEST_DIR=images
SRC_DIR=tmp/contenthub_packages

#
# platform check
#
DEV_ARCH=
case "${BLD_CONFIG_ARCH}" in
x86_64|powerpc)
	DEV_ARCH="${BLD_CONFIG_ARCH}" ;;
ar7100)
	DEV_ARCH="mips" ;;
arm64)
	case ${BLD_CONFIG_KERNEL_CONFIG} in
	ipq*)
		DEV_ARCH="ipq64" ;;
	esac
	;;
esac
if [ -z "${DEV_ARCH}" ]; then
	echo "Unsupported platform ${BLD_CONFIG_ARCH} / kernel config ${BLD_CONFIG_KERNEL_CONFIG}" >&2
	exit 1
fi
#
# firmware version
#
VERSION=`expr "${FIRMWARE_VERSION}" : '\([0-9]*\)\.'`
SUBLEVEL=`expr "${FIRMWARE_VERSION}" : '[0-9]*\.\([0-9]*\)\.'`
PATCHLEVEL=`expr "${FIRMWARE_VERSION}" : '[0-9]*\.[0-9]*\.\([0-9]*\)'`
if [ -z "${VERSION}" -o -z "${SUBLEVEL}" -o -z "${PATCHLEVEL}" ]; then
	echo "Error getting firmware version from FIRMWARE_VERSION=${FIRMWARE_VERSION}" >&2
	exit 1
fi
echo "Firmware ${VERSION}.${SUBLEVEL}.${PATCHLEVEL} (${DEV_ARCH})" >&2
#
# buildpcpkg.sh options
#
PCPKG_OPTIONS="-p ${DEV_ARCH}" PCPKG_FILE_SUFFIX=".pcpkg"
#SVN_REV=`svn info . 2> /dev/null | sed -n -e '/^Revision:[ ]*/ { s///; p; q }'`
BUILDNO=`date +%Y%m%d%H%M`
if [ "${BUILDNO}" -gt 1 ] 2> /dev/null; then
	PCPKG_OPTIONS="${PCPKG_OPTIONS} -b ${BUILDNO}"
	PCPKG_FILE_SUFFIX="-${VERSION}.${SUBLEVEL}.${PATCHLEVEL}-${BUILDNO}${PCPKG_FILE_SUFFIX}"
fi
PCPKG_OPTIONS="${PCPKG_OPTIONS} -x gzip"

#
# .cfg format example:
#
#   NAME="python"
#   FULLNAME="Python"
#   VERSION_NAME="2.7.12"
#   EXTENSIONS="django bluebream bottle"
#   ENVIRONMENT="PYTHONHOME:<MOUNTPOINT>"
#   ENVIRONMENT="PYTHONPATH:<MOUNTPOINT>"
#   ENVIRONMENT="PATH:<MOUNTPOINT>/bin"
#   DEPENDENCY="firmware:60400"
#
# output file example:
#   images/python-2.7.12-django-bluebream-bottle-powerpc-2662.pcpkg
#
[ "${BLD_CONFIG_USE_SQUASHFS4}" = "y" ] \
	&& MKSQUASHFS_BIN=${HOST_TOOL_DIR}/bin/mksquashfs \
	|| MKSQUASHFS_BIN=${HOST_TOOL_DIR}/bin/mksquashfs-lzma
mkdir -p "${DEST_DIR}"
for CFG_FILE in ${SRC_DIR}/*.cfg; do
	PKG_NAME=`basename "${CFG_FILE%.cfg}"`
	PKG_SRC_DIR="${SRC_DIR}/libraries/${PKG_NAME}"
	[ -d "${PKG_SRC_DIR}" ] || exit $?
	PKG_NAME=`sed -n -e '/^NAME="/ { s///; s/"$//; p; q }' "${CFG_FILE}"`
	PKG_FULLNAME=`sed -n -e '/^FULLNAME="/ { s///; s/"$//; p; q }' "${CFG_FILE}"`
	PKG_VERSION=`sed -n -e '/^VERSION_NAME="/ { s///; s/"$//; p; q }' "${CFG_FILE}"`
	PKG_FILE_SFX=`sed -n -e '/^EXTENSIONS="/ { s///; s/"$//; p; q }' "${CFG_FILE}"`
	[ -n "${PKG_FILE_SFX}" ] && PKG_FILE_SFX="-${PKG_FILE_SFX// /-}"
	PKG_FILENAME="${PKG_NAME}-${PKG_VERSION}${PKG_FILE_SFX}-${DEV_ARCH}${PCPKG_FILE_SUFFIX}"
	PKG_OPTS="-d firmware:${VERSION}.${SUBLEVEL}.${PATCHLEVEL}"
	# [Bug#19795] MIPS platform requires the Essential package before
	#             installing any other package
	[ "${BLD_CONFIG_ARCH}" = "ar7100" -a "${PKG_NAME}" != "host-essential" ] \
		&& PKG_OPTS="${PKG_OPTS} -d host-essential:${VERSION}.${SUBLEVEL}.${PATCHLEVEL}"
	LD_LIBRARY_PATH=${abspath}/tmp/usr/local/lib \
	${PACKAGESDIR}/${PACKAGE}/buildpcpkg.sh "${PKG_SRC_DIR}" \
		-S "${MKSQUASHFS_BIN}" \
		-c "${CFG_FILE}" -v "${PKG_VERSION}" \
		-o "${DEST_DIR}/${PKG_FILENAME}" \
		${PCPKG_OPTIONS} ${PKG_OPTS} || exit $?
done
