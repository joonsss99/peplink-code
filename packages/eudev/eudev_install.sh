#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

# File lists
rule_files="50-udev-default.rules 95-udev-late.rules"
bin_files="udevd udevadm"
lib_files="libudev.so*"

# Copy binaries
mkdir -p ${abspath}/${MNT}/bin
for file in $bin_files; do
	cp ${FETCHEDDIR}/src/udev/.libs/${file} ${abspath}/${MNT}/bin/ || exit $?
	${HOST_PREFIX}-strip ${abspath}/${MNT}/bin/${file}
done

# Copy libraries
mkdir -p ${abspath}/${MNT}/lib
for file in $lib_files; do
	cp -d ${FETCHEDDIR}/src/libudev/.libs/${file} ${abspath}/${MNT}/lib/ || exit $?
	${HOST_PREFIX}-strip ${abspath}/${MNT}/lib/${file}
done

# Copy required rules
if [ ! -d ${abspath}/${MNT}/lib/udev/rules.d ]; then
	mkdir -p ${abspath}/${MNT}/lib/udev/rules.d
fi
for file in $rule_files; do
	cp ${FETCHEDDIR}/rules/${file} ${abspath}/${MNT}/lib/udev/rules.d
done

inittab_install $abspath add once "/usr/local/ilink/bin/usbmodem_action.sh"
