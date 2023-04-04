#!/bin/sh

# [Bug#15462] ContentHub package file builder
# TODO add commands to view package info and extract files

usage()
{
	cat << EOF >&2
[Bug#15462] MediaFast ContentHub Package Utility
Usage:
	${0} <directory> -n <name> -v <version> -p <platform> [-f <full name>] [-e <VAR>:<VALUE> [-e ...]] [-d <NAME>:<VERSION> [-d ...]] -o <output file>

	<directory>
		Source directory containing package contents.
	-c <config file>
		ContentHub package config file
		These config values will be overridden by following
		-n|p|f|v|b options
	-n <name>
		Package name.  Must be unique among all other packages.
	-p <platform>
		x86_64, powerpc, mips, ipq64, or generic
	-f <full name>
		Package full name for UI display.
	-v <version>
		Package version in x.y.z numeric format.
	-b <build number>
		Build number of firmware on which the package was built
	-e <name>:<value>
		Declare run time variables.
		Special characters (space, ";", etc.) are not allowed.
		May use "<MOUNTPOINT>" (without quotes) for
		package root path substitution.
	-d <name>:<version>
		Package or firmware dependency.
		Use "firmware" (without quotes) as name for firmware dependency.
	-o <output file>
		Output package file name.
		If omitted, default output to stdout.
	-D <alias>:<docker image file>:<cmdline file>[:<env file>:<configure file>:<start file>:<stop file>]
		Add a Docker image file to the package, with a <cmdline file>
		to indicate how the image should be run, and optionally an
		<env file> for running.
		This option may be used multiple times.
	-x <compression>
		Package compression method.  Supports gzip (default), xz, lzo.
	-S <mksquashfs>
		Specify mksquashfs command

Example:
	${0} tmp/contenthub_packages/python -n python -v 2.7.12 -p "powerpc" -f "Python" -e "PYTHONHOME:<MOUNTPOINT>" -e "PYTHONPATH:<MOUNTPOINT>" -e "PATH:<MOUNTPOINT>/bin" -d "firmware:6.4.0" -o images/python-2.7.12-django-powerpc-2662.pcpkg
	${0} tmp/contenthub_packages/python -c tmp/contenthub_packages/python.cfg -o python-2.7.12-django-powerpc-2662.pcpkg

Example with Docker app:
	${0} /tmp/emptydir -o crosmgt-0.0.1-x86_64-0.pcpkg
		-p generic -b 1
		-c tmp/info.conf
		-D addc:tmp/crosmgt.tar:tmp/crosmgt.cmd:tmp/crosmgt.env:tmp/config.sh:/tmp/start.sh:/tmp/stop.sh
	where the following files may contain:
	info.conf:
		NAME="host-docker-crosmgt"
		FULLNAME="Chromebook Management"
		DESCRIPTION="Management Server for Chrome O/S Devices"
		VERSION="10000"
		DEPENDENCY="host-docker:11301"
		CFG_ORDER="1 2 3 4"
		CFG_1_ID="DOMAIN"
		CFG_1_TYPE="hidden"
		CFG_1_VALUE=""
		CFG_2_ID="REALM"
		CFG_2_TYPE="domain"
		CFG_2_NAME="Realm"
		CFG_2_HINT="E.g. example.domain"
		CFG_2_VALUE=""
		...
	crosmgt.cmd: (should keep options minimum, and should NOT contain:
			--attach/-a, --detach/-d, --env-file, --help,
			--interactive/-i, --isolateion, --name, --pid,
			--restart, --rm --volume-driver)
		<SYS_DOCKER_RUN> --publish ... --hostname <CFG_REALM> ... <SYS_DOCKER_IMG> arg1 arg2 ...
	crosmgt.env: (optional)
		SAMBA_DOMAIN=<CFG_DOMAIN>
		SAMBA_REALM=<CFG_REALM>
		SAMBA_DNS_FORWARD_IP=<SYS_LAN_IP>
		...
	crosmgt.config.sh: (optional)
		# script/exe for validating user config and updating info.conf
	crosmgt.start.sh: (optional)
		# script/exe executed once shortly after the app starts
	crosmgt.stop.sh: (optional)
		# script/exe executed once shortly after the app stops
EOF
}

pcpkg_build_encrypt()
{
	# Default digest changed from md5 (OpenSSL 1.0) to sha256 (OpenSSL 1.1)
	openssl enc -aes-256-cbc -in "${1}" -md md5 -k 4j47mnsdingjnghte4kdskcj | sed -e "1 s/^Salted/Pe1337/"
}

pcpkg_build()
{
	# tools
	local MKSQUASHFS_CMD="${PCPKG_MKSQUASHFS}"
	if [ -z "${MKSQUASHFS_CMD}" ]; then
		MKSQUASHFS_CMD="mksquashfs"
		if ! which ${MKSQUASHFS_CMD} > /dev/null; then
			echo "Error: mksquashfs not found" >&2
			return 254
		fi
	fi
	# tools' version
	local VER_MESG= VER= OPT=
	if ! VER_MESG=`"${MKSQUASHFS_CMD}" -version 2> /dev/null`; then
		echo "Error: Cannot get mksquashfs version" >&2
		return 254
	fi
	VER=`echo "${VER_MESG}" | sed -n -e '/^mksquashfs version \([0-9]*\.[0-9]*\).*/ { s||\1|; p; q }'`
	case "${VER}" in
	4.2|4.3)
		OPT="-all-root -comp ${PCPKG_COMPRESSION}" ;;
	3.0)
		OPT="-all-root -noappend"
		[ "${KERNEL_ARCH}" = "mips" ] && OPT="${OPT} -be"
		;;
	*)
		echo "Error: Invalid mksquashfs version \"${VER}\"" >&2
		return 254
		;;
	esac
	# setup
	if [ ! -d "${PCPKG_IN_DIR}" ]; then
		echo "Error: Package directory ${PCPKG_IN_DIR} not found" >&2
		return 2
	fi
	# create image file
	rm -f "${PCPKG_BIN_FILE}"
	${MKSQUASHFS_CMD} "${PCPKG_IN_DIR}" "${PCPKG_BIN_FILE}" ${OPT}
	if [ ! -f "${PCPKG_BIN_FILE}" ]; then
		echo "Error: Cannot create image file" >&2
		return 3
	fi
	# create config file
	if [ ! -f "${PCPKG_CONF_FILE}" ]; then
		echo "Error: config file not found" >&2
		return 253
	fi
	cat >> "${PCPKG_CONF_FILE}" << EOF
MD5SUM="`md5sum ${PCPKG_BIN_FILE} | cut -d ' ' -f 1`"
EOF
	for SORT_ITEM in MD5SUM BUILDNO VERSION PLATFORM DESCRIPTION FULLNAME NAME; do
		sed -i -n -e "/^${SORT_ITEM}=/ "'!H' \
			-e "/^${SORT_ITEM}=/ { x; H }" \
			-e '${ x; p }' \
			"${PCPKG_CONF_FILE}"
	done
	sed -i -e '/^$/ d' "${PCPKG_CONF_FILE}"
	# create encrypted tar file
	RET=0
	FILE_LIST=
	for F in "${PCPKG_CONF_FILE}" "${PCPKG_BIN_FILE}" "${PCPKG_DOCKER_DIR}"; do
		if [ -f "${F}" -o -d "${F}" ]; then
			FILE_LIST="${FILE_LIST} `basename ${F}`"
		fi
	done
	rm -f "${PCPKG_TMP_TAR_FILE}"
	tar -cvf "${PCPKG_TMP_TAR_FILE}" -C "${PCPKG_BUILD_DIR}" ${FILE_LIST} >&2
	if [ -n "${PCPKG_OUT_FILE}" ]; then
		pcpkg_build_encrypt "${PCPKG_TMP_TAR_FILE}" > "${PCPKG_OUT_FILE}" || RET=4
	else
		pcpkg_build_encrypt "${PCPKG_TMP_TAR_FILE}" || RET=5
	fi
	# verbose
	cat >&2 << EOF

========================================
`cd ${PCPKG_BUILD_DIR} && ls -la *`
========================================
`basename ${PCPKG_CONF_FILE}`
----------------------------------------
`cat "${PCPKG_CONF_FILE}"`
========================================
EOF
	[ -f "${PCPKG_OUT_FILE}" ] && cat >&2 << EOF
`ls -la "${PCPKG_OUT_FILE}"`
========================================
EOF
	return ${RET}
}

version_to_string()
{
	VER_MAJOR="`echo -n ${1} | cut -d '.' -f 1`"
	VER_MINOR="`echo -n ${1} | cut -d '.' -f 2`"
	VER_PATCH="`echo -n ${1} | cut -d '.' -f 3`"
	echo "$((${VER_MAJOR} * 10000 + ${VER_MINOR} * 100 + ${VER_PATCH}))"
}

#
# Main
#
PCPKG_BUILD_DIR=".chub_pcpkg_build"
PCPKG_TMP_TAR_FILE=".chub_pcpkg_build.tar"
PCPKG_IN_DIR= PCPKG_OUT_FILE=
PCPKG_MKSQUASHFS= PCPKG_COMPRESSION="gzip"
PCPKG_CONF_FILE="${PCPKG_BUILD_DIR}/info.conf"
PCPKG_BIN_FILE="${PCPKG_BUILD_DIR}/package.bin"
PCPKG_DOCKER_DIR="${PCPKG_BUILD_DIR}/docker"
PCPKG_DOCKER_IMG_COUNT=0
ERROR_MESG=
rm -rf "${PCPKG_BUILD_DIR}"
if ! mkdir -p "${PCPKG_BUILD_DIR}"; then
	echo "Error: Could not create temporary directory" >&2
	return 1
fi
echo > "${PCPKG_CONF_FILE}" # one empty line, for sed

while [ -n "${1}" ]; do
	if [ "${1:0:1}" = "-" ]; then
		OPT="${1:1}"
		case "${OPT}" in
		f|p|v|b|e|d|n|o|c|x|S|D) # options takes 1 argument
			shift
			if [ -z "${1}" ]; then
				ERROR_MESG="Missing argument for option ${OPT}"
				break
			fi
			case "${OPT}" in
			o)	PCPKG_OUT_FILE="${1}"
				;;
			n)	if echo "${1}" | grep -q "[ ;'\"\$]"; then
					ERROR_MESG="Invalid package name"
					break
				fi
				sed -i -e "/^NAME=/ d; \${ p; s|.*|NAME=\"${1}\"| }" "${PCPKG_CONF_FILE}"
				if ! grep -q '^FULLNAME=' "${PCPKG_CONF_FILE}"; then
					sed -i -e "\${ p; s|.*|FULLNAME=\"${1}\"| }" "${PCPKG_CONF_FILE}"
				fi
				;;
			f)	sed -i -e '/^FULLNAME=/ d' "${PCPKG_CONF_FILE}"
				cat >> "${PCPKG_CONF_FILE}" << EOF
FULLNAME="${1}"
EOF
				;;
			p)	case "${1}" in
				powerpc|mips|ipq64|generic)
					PLATFORM="${1}"
					;;
				x86_64)
					PLATFORM="x86"
					;;
				*)	ERROR_MESG="Invalid platform ${1}"
					break
					;;
				esac
				sed -i -e "/^PLATFORM=/ d; \${ p; s|.*|PLATFORM=\"${PLATFORM}\"| }" "${PCPKG_CONF_FILE}"
				;;
			v)	if echo "${1}" | grep -vq "^[0-9]*\.[0-9]\{1,2\}\.[0-9]\{1,2\}\$"; then
					ERROR_MESG="Invalid version ${1}"
					break
				fi
				VERSION="`version_to_string ${1}`"
				sed -i -e "/^VERSION=/ d; \${ p; s|.*|VERSION=\"${VERSION}\"| }" "${PCPKG_CONF_FILE}"
				;;
			b)	if ! [ "${1}" -ge 0 ] 2> /dev/null; then
					ERROR_MESG="Invalid build number ${1}"
					break
				fi
				sed -i -e "/^BUILDNO=/ d; \${ p; s|.*|BUILDNO=\"${1}\"| }" "${PCPKG_CONF_FILE}"
				;;
			e)	VAR="`echo ${1} | sed -e 's/:.*//'`"
				VALUE="`echo ${1} | sed -e 's/^[^:]*://'`"
				if [ -z "${VAR}" -o -z "${VALUE}" ] \
					|| echo "${VAR}" | grep -q "[ ;'\"]" \
					|| echo "${VALUE}" | grep -q "[;]" \
				; then
					ERROR_MESG="Invalid environment ${1}"
					break
				fi
				cat >> "${PCPKG_CONF_FILE}" << EOF
ENVIRONMENT="${1}"
EOF
				;;
			d)	NAME="`echo ${1} | sed -e 's/:.*//'`"
				VALUE="`echo ${1} | sed -e 's/^[^:]*://'`"
				if [ -z "${NAME}" -o -z "${VALUE}" ] \
					|| echo "${NAME}" | grep -q "[ ;'\"]" \
					|| echo "${VALUE}" | grep -vq "^[0-9]*\.[0-9]\{1,2\}\.[0-9]\{1,2\}\$" \
				; then
					ERROR_MESG="Invalid dependency ${1}"
					break
				fi
				VERSION="`version_to_string ${VALUE}`"
				cat >> "${PCPKG_CONF_FILE}" << EOF
DEPENDENCY="${NAME}:${VERSION}"
EOF
				;;
			c)	if [ ! -f "${1}" ]; then
					ERROR_MESG="Invalid package config file ${1}"
					break
				fi
				# TODO validate file content
				cat "${1}" >> "${PCPKG_CONF_FILE}"
				;;
			D)	if [ -z "${1}" ]; then
					ERROR_MESG="Invalid docker image option ${1}"
					break
				fi
				IMG_CON_NAME=`echo "${1}" | cut -d ':' -f 1`
				IMG_TAR_FILE=`echo "${1}" | cut -d ':' -f 2`
				IMG_CMD_FILE=`echo "${1}" | cut -d ':' -f 3`
				IMG_ENV_FILE=`echo "${1}" | cut -d ':' -f 4`
				IMG_CFG_FILE=`echo "${1}" | cut -d ':' -f 5`
				IMG_STA_FILE=`echo "${1}" | cut -d ':' -f 6`
				IMG_STP_FILE=`echo "${1}" | cut -d ':' -f 7`
				if ! echo "${IMG_CON_NAME}" | grep -q '^[0-9a-zA-Z_-]*$'; then
					ERROR_MESG="Invalid container name ${IMG_CON_NAME} for app image"
					break
				elif [ ! -f "${IMG_TAR_FILE}" ] || ! tar -tf "${IMG_TAR_FILE}" > /dev/null; then
					ERROR_MESG="Invalid docker image file ${IMG_TAR_FILE}"
					break
				elif [ ! -f "${IMG_CMD_FILE}" ]; then
					ERROR_MESG="Missing/Invalid command line file ${IMG_CMD_FILE} for docker image"
					break
				elif [ -n "${IMG_CFG_FILE}" -a ! -f "${IMG_CFG_FILE}" ]; then
					ERROR_MESG="Invalid user config validation file ${IMG_CFG_FILE}"
					break
				elif [ -n "${IMG_ENV_FILE}" -a ! -f "${IMG_ENV_FILE}" ]; then
					ERROR_MESG="Invalid docker container environment file ${IMG_ENV_FILE}"
					break
				elif [ -n "${IMG_STA_FILE}" -a ! -f "${IMG_STA_FILE}" ]; then
					ERROR_MESG="Invalid app start callback file ${IMG_STA_FILE}"
					break
				elif [ -n "${IMG_STP_FILE}" -a ! -f "${IMG_STP_FILE}" ]; then
					ERROR_MESG="Invalid app stop callback file ${IMG_STP_FILE}"
					break
				fi
				PCPKG_DOCKER_IMG_COUNT=$((${PCPKG_DOCKER_IMG_COUNT} + 1))
				if [ "${PCPKG_DOCKER_IMG_COUNT}" -eq 1 ]; then
					sed -i -e '/^DOCKER_ORDER=/ d' \
						-e '${ p; s/.*/DOCKER_ORDER="1"/ }' \
						"${PCPKG_CONF_FILE}"
				else
					sed -i -e "/^\(DOCKER_ORDER=\"[^\"]*\)\(\"\)/ s||\1 ${PCPKG_DOCKER_IMG_COUNT}\2|" \
						"${PCPKG_CONF_FILE}"
				fi
				#
				#
				#
				mkdir -p "${PCPKG_DOCKER_DIR}"
				gzip -cv "${IMG_TAR_FILE}" > "${PCPKG_DOCKER_DIR}/${IMG_CON_NAME}.tar.gz"
				cp -pvf "${IMG_CMD_FILE}" "${PCPKG_DOCKER_DIR}/${IMG_CON_NAME}.cmd"
				cat >> "${PCPKG_CONF_FILE}" << EOF
DOCKER_${PCPKG_DOCKER_IMG_COUNT}_CON_NAME="${IMG_CON_NAME}"
DOCKER_${PCPKG_DOCKER_IMG_COUNT}_IMG_FILE="docker/${IMG_CON_NAME}.tar.gz"
DOCKER_${PCPKG_DOCKER_IMG_COUNT}_CMD_FILE="docker/${IMG_CON_NAME}.cmd"
EOF
				if [ -f "${IMG_CFG_FILE}" ]; then
					cp -pvf "${IMG_CFG_FILE}" "${PCPKG_DOCKER_DIR}/${IMG_CON_NAME}.configure"
					cat >> "${PCPKG_CONF_FILE}" << EOF
DOCKER_${PCPKG_DOCKER_IMG_COUNT}_CFG_FILE="docker/${IMG_CON_NAME}.configure"
EOF
				fi
				if [ -f "${IMG_STA_FILE}" ]; then
					DST_FILE="${IMG_CON_NAME}.start"
					cp -pvf "${IMG_STA_FILE}" "${PCPKG_DOCKER_DIR}/${DST_FILE}"
					cat >> "${PCPKG_CONF_FILE}" << EOF
DOCKER_${PCPKG_DOCKER_IMG_COUNT}_STA_FILE="docker/${DST_FILE}"
EOF
				fi
				if [ -f "${IMG_STP_FILE}" ]; then
					DST_FILE="${IMG_CON_NAME}.stop"
					cp -pvf "${IMG_STP_FILE}" "${PCPKG_DOCKER_DIR}/${DST_FILE}"
					cat >> "${PCPKG_CONF_FILE}" << EOF
DOCKER_${PCPKG_DOCKER_IMG_COUNT}_STP_FILE="docker/${DST_FILE}"
EOF
				fi
				if [ -f "${IMG_ENV_FILE}" ]; then
					cp -pvf "${IMG_ENV_FILE}" "${PCPKG_DOCKER_DIR}/${IMG_CON_NAME}.env"
					cat >> "${PCPKG_CONF_FILE}" << EOF
DOCKER_${PCPKG_DOCKER_IMG_COUNT}_ENV_FILE="docker/${IMG_CON_NAME}.env"
EOF
				fi
				;;
			x)	case "${1}" in
				gzip|xz|lzo)
					PCPKG_COMPRESSION="${1}"
					;;
				*)	ERROR_MESG="Invalid compression method ${1}"
					break
					;;
				esac
				;;
			S)	PCPKG_MKSQUASHFS="${1}"
				;;
			esac
			;;
		*)	ERROR_MESG="Unknown option ${OPT}"
			break
			;;
		esac
	elif [ -z "${PCPKG_IN_DIR}" ]; then
		if [ ! -d "${1}" ]; then
			ERROR_MESG="Invalid directory ${1}"
			break
		fi
		PCPKG_IN_DIR="${1}"
	else
		ERROR_MESG="Invalid option ${1}"
		break
	fi
	shift
done

if [ -z "${ERROR_MESG}" ]; then
	if ! grep '^NAME=' "${PCPKG_CONF_FILE}"; then
		ERROR_MESG="Missing package name"
	elif ! grep '^VERSION=' "${PCPKG_CONF_FILE}"; then
		ERROR_MESG="Missing package version"
	elif ! grep '^PLATFORM=' "${PCPKG_CONF_FILE}"; then
		ERROR_MESG="Missing platform"
	fi
fi
if [ -z "${ERROR_MESG}" ]; then
	pcpkg_build # passing arguments as global variables for now
	RET=$?
else
	echo "Error: ${ERROR_MESG}" >&2
	usage
	RET=1
fi
rm -rf "${PCPKG_BUILD_DIR}" "${PCPKG_TMP_TAR_FILE}"
exit ${RET}
