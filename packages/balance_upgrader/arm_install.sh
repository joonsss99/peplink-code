#!/bin/sh

PACKAGE=$1

abspath=`pwd`

FETCHEDDIR=${abspath}/${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions
. $PACKAGESDIR/common/upgrader_functions

HOST_TOOLS_DIR=$abspath/tools/host/bin
FIWM_BIN=$HOST_TOOLS_DIR/fiwm
VERISIGN_BIN=$HOST_TOOLS_DIR/peplink_sign_firmware

GENEXT2FS="$HOST_TOOLS_DIR/genext2fs"
VMLINUX=${abspath}/images/uImage.fit.pep
FW_VERSION=${abspath}/${MNT}/etc/software-release
VERSION=`cat $FW_VERSION`
UIMAGE_SRC="${KERNEL_OBJ}/arch/$KERNEL_ARCH/boot/uImage.fit.pep.all"
makeflag="ARCH=$KERNEL_ARCH CROSS_COMPILE=$HOST_PREFIX- $MAKE_OPTS"
BUILD_NUMBER=`cat plb.bno`
MTK5G_IMAGES="preloader_evb6890v1_64_cpe.bin.tar.gz "\
"MCF_OTA_1.img.tar.gz "\
"MCF_OTA_2.img.tar.gz "\
"modem-verified.img.tar.gz "\
"dsp-verified.bin.tar.gz "\
"spmfw-verified.img.tar.gz "\
"pi_img-verified.img.tar.gz "\
"dpm-verified.img.tar.gz "\
"medmcu-verified.img.tar.gz "\
"sspm-verified.img.tar.gz "\
"mcupm-verified.img.tar.gz "\
"tee-verified.img.tar.gz "\
"loader_ext-verified.img.tar.gz "\
"lk-verified.img.tar.gz "\
"boot-verified.img "\
"root_ro.sig.tar.gz "\
"root.squashfs"

export PATH="$HOST_TOOL_DIR/bin:$PATH"

create_mtk5g_images()
{
	local MTK5G_IMAGE_DIR=${abspath}/images
	local LINUX_BOOT_PATH=${KERNEL_OBJ}/arch/$KERNEL_ARCH/boot

	# Creating Image.gz and DTB file
	if [ "$FW_CONFIG_KDUMP" = "y" ]; then
		makeflag="$makeflag O=$KERNEL_OBJ"
	fi

	echo -e "${TCOLOR_BGREEN}Creating Image.gz and dtb files...${TCOLOR_NORMAL}"
	if [ ! -f $KERNEL_OBJ/.config ]; then
		echo "${KERNEL_OBJ}: .config file is missing"
		exit 1
	fi

	make -C ${KERNEL_SRC} $makeflag all || exit $?
	# Check the existense of Image.gz
	# Copy to images folder
	if [ ! -f ${LINUX_BOOT_PATH}/Image.gz ]; then
		echo "Image.gz not found"
		exit 1
	fi
	mkdir -p ${MTK5G_IMAGE_DIR}
	cp -f ${LINUX_BOOT_PATH}/Image.gz ${MTK5G_IMAGE_DIR}/

	if [ ! -f ${LINUX_BOOT_PATH}/pismo-dtb.img ]; then
		echo "pismo-dtb.img not found"
		exit 1
	fi
	cp -f ${LINUX_BOOT_PATH}/pismo-dtb.img ${MTK5G_IMAGE_DIR}/

	# Create all MTK5G image from mtk-t750-fw-pkg
	make -C ${abspath}/${FETCHDIR}/mtk-t750-fw-pkg/img install IMAGES=${MTK5G_IMAGE_DIR} || exit $?

	# Check if all images are generated
	for f in ${MTK5G_IMAGES}; do
		if [ ! -f ${MTK5G_IMAGE_DIR}/${f} ]; then
			echo "${f} not found"
			exit 1
		fi
		# Create symlink for the images
		ln -snf ${MTK5G_IMAGE_DIR}/${f} ${f}
	done
}

create_rdisk_vmlinux()
{
	# Creating uImage.fit.pep.all
	if [ "$FW_CONFIG_KDUMP" = "y" ]; then
		makeflag="$makeflag O=$KERNEL_OBJ"
	fi

	echo -e "${TCOLOR_BGREEN}Creating uImage.fit.pep.all ...${TCOLOR_NORMAL}"
	if [ ! -f $KERNEL_OBJ/.config ]; then
		echo "${KERNEL_OBJ}: .config file is missing"
		exit 1
	fi

	rm -f ${UIMAGE_SRC}
	make -C ${KERNEL_SRC} $makeflag all || exit $?
	if [ ! -f ${UIMAGE_SRC} ]; then
		echo "${UIMAGE_SRC} not found"
		exit 1
	fi

	cp -f $UIMAGE_SRC $VMLINUX
	if [ ! -f ${VMLINUX} ]; then
		echo "${VMLINUX} not found"
		exit 1
	fi

	ln -snf ${VMLINUX} $(basename ${VMLINUX})

	if [ "$BLD_CONFIG_USE_SFS" = "y" ]; then
		RDISKIMAGE=${abspath}/images/rdisk.sfs
		TARGET_IMAGE="rdisk.sfs"
	else
		RDISKIMAGE=${abspath}/images/rdisk.gz
		TARGET_IMAGE="rootdisk.tar.gz"
	fi

	if [ ! -f ${RDISKIMAGE} ]; then
		echo "${RDISKIMAGE} not found"
		exit 1
	fi

	ln -snf ${RDISKIMAGE} ${TARGET_IMAGE}
}

if [ ! -f ${FW_VERSION} ]; then
	echo "${FW_VERSION} not found"
	exit 1
fi

cp -f ${FW_VERSION} ${abspath}/${UPGRADER_ROOT_DIR}/

cd ${FETCHEDDIR}

if [ "$BUILD_TARGET" = "mtk5g" ]; then
	RDISKIMAGE=${abspath}/images/root.squashfs
	KERNEL_IMAGE=${abspath}/images/boot-verified.img
	create_mtk5g_images

	mkdir -p ${abspath}/${UPGRADER_ROOT_DIR}/bin
else
	KERNEL_IMAGE=${UIMAGE_SRC}
	create_rdisk_vmlinux
fi

case $BUILD_TARGET in
ipq|apone|aponeax|maxdcs_ipq|ipq64|mtk5g|sfchn)
	EXT2OVRHD=1792
	;;
*)
	echo_error "invalid build target $BUILD_TARGET"
	exit 1
	;;
esac

if [ $USE_FAKEROOT -eq 1 ] ; then
	#echo "fakeroot_cmd=$fakeroot_cmd"
	fakeroot_cmd="$FAKEROOT -p $abspath/fakeroot_upgrader -d"
else
	fakeroot_cmd=""
fi

export WEB_DIR="$BALANCE_WEB_DIR"

if [ "$BLD_CONFIG_ENCRYPT_FIRMWARE" = "y" ] ; then
	PARAM_ENCRYPT_FW="1"
	PARAM_ENCRYPT_KEY="${abspath}/${ENCRYPT_FW_PUBLIC_KEY}"
fi

case $BUILD_TARGET in
ipq|apone|aponeax|maxdcs_ipq|ipq64|sfchn)
	REQUIRED_IMAGES="$(basename $VMLINUX) ${TARGET_IMAGE}"
	;;
mtk5g)
	REQUIRED_IMAGES="${MTK5G_IMAGES}"
	;;
*)
	echo_error "Failed to build upgrader disk image"
	exit 1
	;;
esac

if ! $fakeroot_cmd ./mk-arm-pkg.sh $EXT2OVRHD $PARAM_ENCRYPT_FW \
	$PARAM_ENCRYPT_KEY "$REQUIRED_IMAGES"; then
	echo_error "Failed to build required images: $REQUIRED_IMAGES"
	exit 1
fi

firmware_package_and_sign ${KERNEL_IMAGE} ${RDISKIMAGE} || exit $?
