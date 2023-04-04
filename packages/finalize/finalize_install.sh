#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

#. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

# This script should contain misc stuff that must be done after all
# packages are installed, and before rootdisk is packaged.
LIB_DIR=$abspath/$MNT/usr/local/ilink/lib

if [ -d "${LIB_DIR}" ]; then
	for ko in $(find "${LIB_DIR}" -name '*.ko'); do
		${HOST_PREFIX}-strip --strip-debug $ko
	done
fi


#
# Encrypt private key files with passphrase = lowercase(md5sum(/etc/software-release))
#
keypaths_file="$abspath/$MNT/var/run/ilink/.keypaths"
keypass_file="$abspath/keypass.last"

# define the to-be-encrypted default private key files
# TODO: /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key should be
#       generated on devices when they bootup with factory default config
keypaths_list="/etc/.ssh/ra-ic2.dsa.key /etc/.ssh/ra-ic2.rsa.key /etc/.ssh/ra.key /etc/nginx/cert.key /etc/nginx/certs/web-admin.default.key /etc/nginx/certs/device-pepwave-com.key /etc/nginx/certs/guest-portal.oem.key /etc/nginx/certs/guest-portal.default.key /etc/nginx/certs/web-admin.patton.key /etc/nginx/certs/webproxy-portal.key /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key /var/run/ilink/wtp/device.peplink.com.key.pem"

password=`md5sum $abspath/$MNT/etc/software-release | cut -d ' '  -f 1 | tr '[:upper:]' '[:lower:]'`
[ -f ${keypass_file} ] && password_last=`cat ${keypass_file}`

rm -f ${keypaths_file}
for f in ${keypaths_list} ; do
	keypath=$abspath/$MNT/$f

	[ ! -f ${keypath} ] && continue
	echo "$f" >> ${keypaths_file}

	if [ "$password" = "$password_last" ]; then
		# password unchanged, check if the keypath encrypted or not
		grep -q "BEGIN ENCRYPTED PRIVATE KEY" $keypath && continue # already encrypted
	fi

	rm -f $keypath.enc
	echo -n "encrypting $f ..."
	openssl pkey -aes256 -in $keypath -out $keypath.enc -passout pass:$password -passin pass:$password_last
	if [ -s $keypath.enc ]; then
		mv $keypath.enc $keypath
		echo OK
	else
		rm -f $keypath.enc
		echo FAIL
		exit 1
	fi
done
echo -n $password > ${keypass_file}
