#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

INSTALL_PYC= INSTALL_SO= INSTALL_EXTRA=
PYTHON_PREFIX=`sed -n -e '/^prefix=[ \t]*/ { s///; p; q }' "${FETCHEDDIR}/Makefile"`
PYTHON_SITES="balance_sdk" # put "django" here to package Django into Python
PYTHON_VERSION_XY=`sed -n -e '/^VERSION=[ \t]*/ { s|||; p; q }' "${FETCHEDDIR}/Makefile"`
PYTHON_VERSION_XYZ=`sed -n -e '/^#define[ \t]*PY_VERSION[ \t]*"\([^"]*\)"/ { s||\1|; p; q }' "${FETCHEDDIR}/Include/patchlevel.h"`
[ -n "${PYTHON_VERSION_XY}" -a -n "${PYTHON_VERSION_XYZ}" ] || exit $?
if [ "${HAS_CONTENTHUB_PACKAGES}" = "y" ]; then
	[ -n "${PYTHON_PREFIX}" ] || exit $?
	PYTHON_DESTDIR="${abspath}/tmp/contenthub_packages"
	PYTHON_DEST_PREFIX_DIR="${PYTHON_DESTDIR}${PYTHON_PREFIX}"
	INSTALL_PYC="all" # install everything as is; plenty of space
	INSTALL_SO="yes"
	INSTALL_EXTRA="yes"
elif [ "${HAS_FIRMWARE_MODULES}" = "y" ]; then
	[ -n "${PYTHON_PREFIX}" ] || exit $?
	PYTHON_DESTDIR="${abspath}/tmp/python3"
	PYTHON_DEST_PREFIX_DIR="${PYTHON_DESTDIR}${PYTHON_PREFIX}"
	INSTALL_PYC="opt-1" # install only pyc optimized for size
else
	PYTHON_DESTDIR="${abspath}/${MNT}"
	PYTHON_DEST_PREFIX_DIR="${PYTHON_DESTDIR}/usr"
	INSTALL_PYC="opt-2" # install only pyc optimized for speed
	INSTALL_SO="yes"
	if [ "${BLD_CONFIG_SECURITY_APPARMOR_UTILS}" = "y" ]; then
		PYTHON_SITES="apparmor LibAppArmor"
	fi
fi
PY2TO3="${HOST_TOOL_DIR}/python3/usr/bin/python3 ${HOST_TOOL_DIR}/python3/usr/bin/2to3"
PYTHON_HOME_DIR="${PYTHON_DEST_PREFIX_DIR}/lib/python${PYTHON_VERSION_XY}"
PYTHON_SITES_DIR="${PYTHON_HOME_DIR}/site-packages"
PYTHON_DYNLOAD_DIR="${PYTHON_HOME_DIR}/lib-dynload"
#
# Sites/frameworks
#   Goes before make install, which compiles .py in site-packages
#
if [ -n "${PYTHON_SITES}" ]; then
	mkdir -p "${PYTHON_SITES_DIR}" "${PYTHON_DYNLOAD_DIR}" || exit $?
	for SITE in ${PYTHON_SITES}; do
		SITE_SRC_DIR="${abspath}/tmp/${SITE}"
		if [ ! -d "${SITE_SRC_DIR}" ]; then
			echo "Required framework ${SITE} not found"
			exit 1
		fi
		case ${SITE} in
		balance_sdk)
			rm -rf "${PYTHON_SITES_DIR}/peplink"
			cp -dpR "${SITE_SRC_DIR}/python2" "${PYTHON_SITES_DIR}/peplink" || exit $?
			# convert 2to3 using default fixers, always modify files
			for i in `find "${PYTHON_SITES_DIR}/peplink" -name "*.py"`; do
				${PY2TO3} -w -W -n "${i}" > /dev/null || exit $?
			done
			;;
		*)
			rm -rf "${PYTHON_SITES_DIR}/${SITE}"
			cp -dpR "${SITE_SRC_DIR}" "${PYTHON_SITES_DIR}/${SITE}"
			find "${PYTHON_SITES_DIR}/${SITE}" -name "*.so" \
				| xargs -i mv -f {} "${PYTHON_DYNLOAD_DIR}/" || exit $?
			;;
		esac
	done
fi
#
# Install
#
export PATH="${HOST_TOOL_DIR}/python3/usr/bin:${PATH}"
make -C "${FETCHEDDIR}" ${MAKE_OPTS} \
	DESTDIR="${PYTHON_DESTDIR}" \
	bininstall libinstall sharedinstall || exit $?
#
# Strip and trim
#   Note: .../usr/bin/python3.7m which is a hard link to .../usr/bin/python3.7
#   Remove *.a
#
${HOST_PREFIX}-strip --strip-all \
	${PYTHON_DEST_PREFIX_DIR}/bin/python${PYTHON_VERSION_XY} || exit $?
rm -f ${PYTHON_DEST_PREFIX_DIR}/lib/libpython*.a
if [ "${INSTALL_SO}" = "yes" ]; then
	${HOST_PREFIX}-strip --strip-all \
		${PYTHON_DEST_PREFIX_DIR}/lib/*/lib-dynload/*.so || exit $?
else
	rm -fv ${PYTHON_DEST_PREFIX_DIR}/lib/*/lib-dynload/*.so
fi
if [ ! "${INSTALL_EXTRA}" = "yes" ]; then
	for i in lib2to3 distutils idlelib ensurepip pydoc_data turtledemo \
		unittest tkinter sqlite3 test; do
		echo "Removing ${i}..."
		rm -rf ${PYTHON_DEST_PREFIX_DIR}/lib/python${PYTHON_VERSION_XY}/${i}
	done
fi
#
# .pyc
#
case "${INSTALL_PYC}" in
all)
	# Do nothing
	;;
opt-1|opt-2)
	echo "Replacing py module with pyc (${INSTALL_PYC})"
	for PYCACHE in `find "${PYTHON_DEST_PREFIX_DIR}" -name __pycache__`; do
		echo "Processing ${PYCACHE}..."
		for PYC in `ls ${PYCACHE}/*.pyc`; do
			BASENAME=`basename "${PYC}"`
			NAME="${BASENAME%%.*}"
			if expr match "${PYC}" ".*\.${INSTALL_PYC}\.pyc" > /dev/null; then
				mv -fv "${PYC}" "${PYCACHE}/../${NAME}.pyc"
				rm -f "${PYCACHE}/../${NAME}.py"
			else
				rm -f "${PYC}"
			fi
		done
		rmdir "${PYCACHE}" 2> /dev/null
	done
	;;
*)
	echo "Removing all __pycache__..."
	find "${PYTHON_DEST_PREFIX_DIR}" -name __pycache__ | xargs rm -rf
	;;
esac
#
# Create .cfg file for contenthub_packager
#
if [ "${HAS_CONTENTHUB_PACKAGES}" = "y" ]; then
	PYTHON_DEST_CFG="${PYTHON_DESTDIR}/python3.cfg"
	cat > "${PYTHON_DEST_CFG}" << EOF
NAME="python3"
FULLNAME="Python 3"
VERSION_NAME="${PYTHON_VERSION_XYZ}"
EXTENSIONS="${PYTHON_SITES}"
ENVIRONMENT="PYTHONHOME:<MOUNTPOINT>"
ENVIRONMENT="PYTHONPATH:<MOUNTPOINT>"
ENVIRONMENT="PATH:<MOUNTPOINT>/bin"
EOF
elif [ "${HAS_FIRMWARE_MODULES}" = "y" ]; then
	DEST_MODULE="${abspath}/tmp/python3.squashfs"
	[ "${BLD_CONFIG_USE_SQUASHFS4}" = "y" ] \
		&& MKSQUASHFS_BIN=${HOST_TOOL_DIR}/bin/mksquashfs \
		|| MKSQUASHFS_BIN=${HOST_TOOL_DIR}/bin/mksquashfs-lzma
	if ! VER_MESG=`"${MKSQUASHFS_BIN}" -version 2> /dev/null`; then
		echo "Error: Cannot get mksquashfs version" >&2
		exit 254
	fi
	VER=`echo "${VER_MESG}" | sed -n -e '/^mksquashfs version \([0-9]*\.[0-9]*\).*/ { s||\1|; p; q }'`
	case "${VER}" in
	4.2|4.3)
		OPT="-all-root -comp gzip" ;;
	3.0)
		OPT="-all-root -noappend"
		[ "${KERNEL_ARCH}" = "mips" ] && OPT="${OPT} -be"
		;;
	*)
		echo "Error: Invalid mksquashfs version \"${VER}\"" >&2
		exit 254
		;;
	esac
	${MKSQUASHFS_BIN} "${PYTHON_DEST_PREFIX_DIR}" "${DEST_MODULE}" ${OPT} || exit $?
	# TODO encrypt the squashfs image created
fi
