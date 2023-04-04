#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

export CROSS_COMPILE=$HOST_PREFIX-

if [ "${BLD_CONFIG_MEDIAFAST_WEBPROXY}" = "y" ]; then
	MAKE_OPTS="${MAKE_OPTS} MFA=1"
fi

if [ "${BLD_CONFIG_IOTOOLS}" = "y" ]; then
	MAKE_OPTS="${MAKE_OPTS} IOTOOLS=1"
fi

case $PL_BUILD_ARCH in
x86|x86_64|native-*)
	case $BUILD_TARGET in
	fhvm)
		MODEL_ARG="FHVM=1"
		;;
	vbal)
		MODEL_ARG="VBAL=1"
		;;
	*)
		MODEL_ARG="BALANCE_700=1"
		;;
	esac

	make -C ${FETCHEDDIR} ${MODEL_ARG} CC=$HOST_PREFIX-gcc STRIP=$HOST_PREFIX-strip AR=$HOST_PREFIX-ar $MAKE_OPTS || exit 1
	;;
ar7100)
	if [ "${BUILD_TARGET}" = "m700" ]; then
		EXTRA_FLAG_T="MAX_700=1"
	elif [ "${BUILD_TARGET}" = "maxdcs" ]; then
		EXTRA_FLAG_T="MAX_DCS=1"
	elif [ "${BUILD_TARGET}" = "aponeac" ]; then
		EXTRA_FLAG_T="APONE=1"
	elif [ "${BUILD_TARGET}" = "maxotg" ]; then
		EXTRA_FLAG_T="MAX_OTG=1"
	elif [ "${BUILD_TARGET}" = "maxbr1" ]; then
		EXTRA_FLAG_T="MAX_OTG=1"
	elif [ "${BUILD_TARGET}" = "maxbr1ac" ]; then
		EXTRA_FLAG_T="MAX_OTG=1"
	elif [ "${BUILD_TARGET}" = "plsw" ]; then
		EXTRA_FLAG_T="PLSW=1"
	elif [ "${BUILD_TARGET}" = "balance310b" -o "${BUILD_TARGET}" = "balance210b" ]; then
		EXTRA_FLAG_T="BALANCE_210B=1"
	else
		EXTRA_FLAG_T="BALANCE_20B=1"
	fi
	make -C ${FETCHEDDIR} ${EXTRA_FLAG_T} KERNEL_PATH=${KERNEL_DIR} $MAKE_OPTS || exit 1
	;;
powerpc)
	if [ "${BUILD_TARGET}" = "maxhd4" ]; then
                EXTRA_FLAG_T="MAX_700=1"
	elif [ "${BUILD_TARGET}" = "maxdcs_ppc" ]; then
		EXTRA_FLAG_T="MAX_DCS=1"
	fi
	make -C ${FETCHEDDIR} ${EXTRA_FLAG_T} KERNEL_PATH=${KERNEL_DIR} HOST_PREFIX=${HOST_PREFIX} $MAKE_OPTS || exit 1
	;;
arm|arm64|ramips)
	case $BUILD_TARGET in
	ipq|ipq64|mtk5g|ramips)
		EXTRA_FLAG_T="MAX_700=1"
		;;
	apone|aponeac)
		EXTRA_FLAG_T="APONE=1"
		;;
	aponeax)
		EXTRA_FLAG_T="APONEAX=1"
		;;
	maxdcs_ipq|maxdcs_ramips)
		EXTRA_FLAG_T="MAX_DCS=1"
		;;
	sfchn)
		EXTRA_FLAG_T="SFCHN=1"
		;;
	*)
		echo_error "arch $PL_BUILD_ARCH target $BUILD_TARGET not supported"
		exit 1
		;;
	esac
	make -C ${FETCHEDDIR} ${EXTRA_FLAG_T} KERNEL_PATH=${KERNEL_DIR} HOST_PREFIX=${HOST_PREFIX} $MAKE_OPTS || exit 1
	;;
*)
	echo_error "arch $PL_BUILD_ARCH not supported"
	exit 1
	;;
esac
# Install the timezone.h and lib to the staging
cp -pf ${FETCHEDDIR}/libtimezone/timezone.h ${STAGING}/usr/include
cp -pf ${FETCHEDDIR}/libtimezone/libtimezone.a ${STAGING}/usr/lib

# linkusage
cp -pf $FETCHEDDIR/liblinkusage/liblinkusage.h $STAGING/usr/include
cp -pf $FETCHEDDIR/liblinkusage/liblinkusage.a $STAGING/usr/lib

cp -pf $FETCHEDDIR/libclientrate/libclientrate.h $STAGING/usr/include
cp -pf $FETCHEDDIR/libclientrate/libclientrate.a $STAGING/usr/lib
