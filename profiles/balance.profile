# vim: set syntax=make:

PWD := $(shell pwd)
TOP := .
MNT := $(TOP)/tmp/mnt
ISO_MNT := $(TOP)/tmp/isomnt
PROFILESDIR := $(TOP)/profiles
PACKAGESDIR := $(TOP)/packages
FETCHDIR := $(TOP)/fetched
HELPERS := $(TOP)/helpers
SCRIPTS := $(TOP)/scripts
PKGVERS := $(PROFILESDIR)/pkgversion.lock
STAGING := $(PWD)/staging
HOST_MODE := baremetal
PROJECT_MAKE := $(PWD)/project.mk
HOST_TOOL_DIR := $(PWD)/tools/host
TOOLCHAIN_BASE_PATH := /opt/peplink

# Pre-built of staging/install files
-include prebuilt.option
TOP_PREBUILT_EX := $(PWD)/projects_export
TOP_PREBUILT_IM := $(PWD)/projects_import
ifneq ("$(BLD_CONFIG_PREBUILT_IMPORT)","y")
	PROJECT_SOURCE := y
endif

OBJTREE := objtree
UPGRADER_OBJTREE := upgdr-objtree

CFG_VERSION := 8.0
#FIRMWARE_IS_JFFS := yes
FINAL_RELEASE := no
BUILD_UPGRADER_PACKAGE := no

# SVN_SERVER should have no trailing slash (/)
SVN_SERVER := http://svn.peplink.com/svn

#
# Configurable items
#
#BLD_CONFIG_SIGNAL_BAR             - has signal bar
#BLD_CONFIG_CF_LICENSE             - use CF card as license key
#BLD_CONFIG_DM_CRYPT_PARTITION     - has dm crypt partition
#BLD_CONFIG_BALANCE_FRONTPANEL     - has front panel for Balance
#BLD_CONFIG_GOBI                   - built in Gobi modem
#BLD_CONFIG_MEDIAFAST_BUILT_IN     - whether MediaFast features should be built into firmware
#BLD_CONFIG_MEDIAFAST_WEBPORXY     - support webproxy (MediaFast)
#BLD_CONFIG_MEDIAFAST_CONTENTHUB   - support ContentHub
#BLD_CONFIG_MEDIAFAST_DOCKER       - support Docker
#BLD_CONFIG_MDM                    - support mobile device management
#BLD_CONFIG_MODEM                  - include modem drivers
#BLD_CONFIG_MODEM_ADVANCE          - include modem userland programmes
#BLD_CONFIG_EUDEV                  - support udev
#BLD_CONFIG_IOTOOLS                - support iotools (btalk, poe, hwmon and fb)
#BLD_CONFIG_USE_RAMFS              - build recovery ramfs to kernel
#BLD_CONFIG_X86_RESET_BUTTON       - support Lanner hardware with reset button
#BLD_CONFIG_SMP                    - include smp utilities
#BLD_CONFIG_TCPDUMP                - include tcpdump utility
#BLD_CONFIG_BALANCE_FULL_FEATURE   - include OPTIONAL_PACKAGE, not for devices with not enough space
#BLD_CONFIG_FHVM                   - Fusion VM
#BLD_CONFIG_DCS                    - Device Connector series
#BLD_CONFIG_USE_SFS                - use squashfs (instead of SD card)
#BLD_CONFIG_BALANCE_KMOD           - balance_kmod
#BLD_CONFIG_SPEEDFUSION            - speedfusion
#BLD_CONFIG_CLI                    - CLI
#BLD_CONFIG_LIBREMOTESIM           - Library for Remote SIM
#BLD_CONFIG_REMOTESIM              - Remote SIM App
#BLD_CONFIG_NETFLOW                - Netflow Support

#HAS_UPGRADER               - ?
#HAS_CONTENTHUB_PACKAGES    - [Bug#15462] build contenthub packages
#HAS_LZMA                   - build tools/host/liblzma (variable seems unused)

# TARGET_SERIES and BUILD_TARGET has the same function in scripts and makefiles
# even though they have different name

include configs/$(BUILD_TARGET)_defconfig

PL_BUILD_ARCH := $(BLD_CONFIG_ARCH)
FIRMWARE_MODEL_LIST := $(BLD_CONFIG_FW_MODEL_LIST)

BLD_CONFIG_WLAN_STATS_NG := $(or $(BLD_CONFIG_WLC),$(BLD_CONFIG_WIFI))

KERNEL_CONFIG_NAME := $(BLD_CONFIG_KERNEL_CONFIG)_defconfig
KDUMP_CONFIG_NAME := $(BLD_CONFIG_KERNEL_KDUMP_CONFIG)_defconfig

ifeq ("$(BUILD_TARGET)","m700")
	TARGET_SERIES := pwm_m700
	BUILD_MODEL := bs
else ifeq ("$(BUILD_TARGET)","maxdcs")
	TARGET_SERIES := pwmdcs
	BUILD_MODEL := bs
else ifeq ("$(BUILD_TARGET)","maxdcs_ipq")
	TARGET_SERIES := ipq
	BUILD_MODEL := bs
else ifeq ("$(BUILD_TARGET)","maxdcs_ppc")
	TARGET_SERIES := pwm_hd4
	BUILD_MODEL := bs
else ifeq ("$(BUILD_TARGET)","maxdcs_ramips")
	TARGET_SERIES := ramips
	BUILD_MODEL := bs
else ifeq ("$(BUILD_TARGET)","maxbr1ac")
	TARGET_SERIES := maxbr1ac
	BUILD_MODEL := bs
else ifeq ("$(BUILD_TARGET)","sfchn")
	# Peplink Relay
	TARGET_SERIES := ipq
	BUILD_MODEL := bs
else ifeq ($(filter-out "maxotg" "chub_maxotg" "module_maxotg","$(BUILD_TARGET)"),)
	# [Bug#15462][Bug#19795] chub_maxotg is ContentHub packages for maxotg
	TARGET_SERIES := pwmotg
	BUILD_MODEL := bs
else ifeq ($(filter-out "balance2500" "chub_balance2500","$(BUILD_TARGET)"),)
	# [Bug#15462] chub_balance2500 is ContentHub packages for balance2500
	TARGET_SERIES := plb_x86_64
	BUILD_MODEL := bs
	LICENSE_PUBLIC_KEY = keys/license/public.license.key.plb700
	LICENSE_PRIVATE_KEY = keys/license/private.license.key.plb700
else ifeq ("$(BUILD_TARGET)","apx")
	TARGET_SERIES := apx
	BUILD_MODEL := bs
	LICENSE_PUBLIC_KEY = keys/license/public.license.key.apx
	LICENSE_PRIVATE_KEY = keys/license/private.license.key.apx
else ifeq ($(filter-out "maxhd4" "chub_maxhd4","$(BUILD_TARGET)"),)
	# [Bug#15462] chub_pwm_hd4 is ContentHub packages for pwm_hd4
	TARGET_SERIES := pwm_hd4
	BUILD_MODEL := bs
else ifeq ("$(BUILD_TARGET)","ipq")
	TARGET_SERIES := ipq
	BUILD_MODEL := bs
else ifeq ("$(BUILD_TARGET)", "vbal")
	TARGET_SERIES := vbal
	BUILD_MODEL := bs
	HOST_MODE := vm
	LICENSE_PUBLIC_KEY = keys/license/public.license.key.vbal
	LICENSE_PRIVATE_KEY = keys/license/private.license.key.vbal
else ifeq ("$(BUILD_TARGET)","apone")
	TARGET_SERIES := ipq
	BUILD_MODEL := bs
else ifeq ("$(BUILD_TARGET)","aponeac")
	# aponeac is pwmdcs but has ethernet WAN instead of Wi-Fi WAN
	# looks like hack as creates problems with magicblk for ramips !!!
	TARGET_SERIES := pwmdcs
	BUILD_MODEL := bs
else ifeq ("$(BUILD_TARGET)","aponeax")
	TARGET_SERIES := ipq64
	BUILD_MODEL := bs
else ifeq ("$(BUILD_TARGET)","fhvm")
	TARGET_SERIES := fhvm
	BUILD_MODEL := fh
	HOST_MODE := vm
else ifeq ("$(BUILD_TARGET)","plsw")
	TARGET_SERIES := plsw
	# a firmware list for ecos config !! filename format: ${MODEL}-HW${HWVER} !!
	TARGET_OFFLOAD_SW_CFG_LIST := PLSW8S2-HW1
	TARGET_OFFLOAD_SW_CFG_LIST += PLSW16S2-HW1
	TARGET_OFFLOAD_SW_CFG_LIST += PLSW24S2-HW1
	TARGET_OFFLOAD_SW_CFG_LIST += PLSW24S2-HW2
	TARGET_OFFLOAD_SW_CFG_LIST += PLSW48S4-HW1
	BUILD_MODEL := bs
else ifeq ($(filter-out ipq64 chub_ipq64,$(BUILD_TARGET)),)
	TARGET_SERIES := ipq64
	BUILD_MODEL := bs
else ifeq ("$(BUILD_TARGET)","ramips")
	TARGET_SERIES := ramips
	BUILD_MODEL := bs
else ifeq ("$(BUILD_TARGET)","native_x86")
# native target is very special, not used for building a complete firmware
	TARGET_SERIES := native
else ifeq ("$(BUILD_TARGET)","mtk5g")
	TARGET_SERIES := mtk5g
	BUILD_MODEL := bs
else
$(error Unknown BUILD_TARGET: "$(BUILD_TARGET)" in file firmware.model)
endif

# [Bug#15462] uncomment below for embedding ContentHub packages into firmware
# HAS_CONTENTHUB_PACKAGES := y
ifeq ($(firstword $(subst _, ,$(BUILD_TARGET))),chub)
	HAS_CONTENTHUB_PACKAGES := y
endif
ifeq ("$(BLD_CONFIG_USE_SQUASHFS4)","y")
	HOST_TOOL_SQUASHFS_4 := y
endif

# [Bug#19795]
_VAR_LIST := $(filter BLD_CONFIG_MEDIAFAST_%,$(.VARIABLES))
ifeq ($(BLD_CONFIG_MEDIAFAST_BUILT_IN),y)
	ifeq ($(findstring y,$(foreach VAR,$(filter-out BLD_CONFIG_MEDIAFAST_BUILT_IN,$(_VAR_LIST)),$(value $(VAR)))),)
		$(error At least one MediaFast feature must be enabled before setting the BLD_CONFIG_MEDIAFAST_BUILT_IN variable)
	endif
endif
HAS_MEDIAFAST_CORE := $(findstring y,$(BLD_CONFIG_MEDIAFAST_WEBPROXY)$(BLD_CONFIG_MEDIAFAST_CONTENTHUB)$(BLD_CONFIG_MEDIAFAST_DOCKER)$(BLD_CONFIG_KVM))
HAS_STORAGE_MGMT_TOOLS := $(HAS_MEDIAFAST_CORE)
BUSYBOX_CONFIG := pepos_config

BLD_CONFIG_WGET := $(findstring y,$(BLD_CONFIG_MEDIAFAST_WEBPROXY)$(BLD_CONFIG_MEDIAFAST_CONTENTHUB)$(BLD_CONFIG_MEDIAFAST_DOCKER))

ifeq ("$(PL_BUILD_ARCH)","ar7100")
	ARCH_BITNESS := 32
	BUILD_FAKEROOT := y
	HAS_LZMA := y
	HOST_PREFIX := mips-peplink-linux-gnu
	TOOLCHAIN_VERSION := 20160222
# FIXME this is for glibc-2.19 (glibc-2.28 and above can use slimmer timezone file)
# we don't need this flag once we have all toolchains using newer glibc
# see usage in packages/timezone/timezone_build.sh
	export TIMEZONE_OLD_GLIBC_COMPAT=y
	KERNEL_ARCH := mips
	KIMAGE_NAME := vmlinux.bin

	ifeq ("$(BLD_CONFIG_USE_SFS)","y")

		ifeq ("$(BLD_CONFIG_ENCRYPT_RDISK)", "y")
			ENCRYPT_RDISK_KEY = keys/partition/ar71xx/cryptsetup.key
		else
			ifneq ($(BLD_CONFIG_RDISK_SIZE),)
				RDISK_SIZE := $(BLD_CONFIG_RDISK_SIZE)
			else
				RDISK_SIZE := 16711680
			endif
		endif

		ifneq ("$(BLD_CONFIG_USE_SQUASHFS4)","y")
			HOST_TOOL_SQUASHFS_3 := y
		endif
	endif

	rdisk-pkg-y := peplink_balance_tgz_image_build
	# override if we build squashfs image
	rdisk-pkg-$(BLD_CONFIG_USE_SFS) := peplink_balance_squashfs_image_build

	upgrader-pkg := balance_upgrader
else ifeq ("$(PL_BUILD_ARCH)","x86_64")
	ARCH_BITNESS := 64
	ifeq ("$(BUILD_TARGET)","fhvm")
		ENCRYPT_RDISK_KEY = keys/partition/fhvm/part5.key
	else
		ENCRYPT_RDISK_KEY = keys/partition/x86/part
	endif
	FW_CONFIG_KDUMP := y
	ifeq ("$(BUILD_TARGET)","apx")
		KDUMP_DM_CRYPT_PARTITION=y
	endif
	HOST_PREFIX := x86_64-peplink-linux-gnu
	TOOLCHAIN_VERSION := 2021a
	KERNEL_ARCH := x86
	KIMAGE_NAME := bzImage
	KIMAGE_DUMP_NAME := $(KIMAGE_NAME)
	rdisk-pkg-y := MANGA_balance_image_build
#probably not correct since there might be some 32bit binaries in it.
	upgrader-pkg := balance_upgrader
else ifeq ("$(PL_BUILD_ARCH)","powerpc")
	HAS_UPGRADER := y
	ARCH_BITNESS := 32
	BUILD_FAKEROOT := y
	HAS_LZMA := y
	FW_CONFIG_KDUMP := y
	HOST_PREFIX := powerpc-peplink-linux-gnuspe
	TOOLCHAIN_VERSION := 20200608
	KERNEL_ARCH := powerpc
	KIMAGE_NAME := uImage.fit.pep.initrd.all
	KIMAGE_DUMP_NAME := uImage
	upgrader-pkg := u-boot-fw-utils balance_upgrader
else ifeq ("$(PL_BUILD_ARCH)","arm")
	HAS_UPGRADER := y
	ARCH_BITNESS := 32
	BUILD_FAKEROOT := y
	FW_CONFIG_KDUMP := y
	HOST_PREFIX := armv7-peplink-linux-gnueabi
	TOOLCHAIN_VERSION := 2021a
	KERNEL_ARCH := arm
	KIMAGE_NAME := uImage.fit.pep.all
	KIMAGE_DUMP_NAME := zImage
	RDISK_SIZE := 24068672
	rdisk-pkg-y := u-boot-fw-utils
	rdisk-pkg-$(BLD_CONFIG_USE_SFS) += peplink_balance_squashfs_image_build
	upgrader-pkg := balance_upgrader
else ifeq ("$(PL_BUILD_ARCH)","arm64")
	HAS_UPGRADER := y
	ARCH_BITNESS := 64
	BUILD_FAKEROOT := y
	ifeq ("$(BUILD_TARGET)","mtk5g")
		TOOLCHAIN_VERSION := 2021c
		HOST_PREFIX := aarch64-openwrt-linux-musl
		STAGING_DIR := ""
		KIMAGE_NAME := Image.gz
		rdisk-pkg-$(BLD_CONFIG_USE_SFS) := peplink_balance_squashfs_image_build
		upgrader-pkg := mtk-t750-fw-pkg balance_upgrader
	else
		TOOLCHAIN_VERSION := 2021a
		FW_CONFIG_KDUMP := y
		HOST_PREFIX := aarch64-peplink-linux-gnu
		rdisk-pkg-y := u-boot-fw-utils
		rdisk-pkg-$(BLD_CONFIG_USE_SFS) += peplink_balance_squashfs_image_build
		KIMAGE_NAME := uImage.fit.pep.all
		KIMAGE_DUMP_NAME := Image.gz
		upgrader-pkg := balance_upgrader
	endif
	KERNEL_ARCH := arm64
	RDISK_SIZE := 67108864
else ifeq ("$(PL_BUILD_ARCH)","ramips")
	HAS_UPGRADER := y
	HAS_LZMA := y

	ARCH_BITNESS := 32
	BUILD_FAKEROOT := y
	#FW_CONFIG_KDUMP := y
	HOST_PREFIX := mipsel-peplink-linux-gnu
	TOOLCHAIN_VERSION := 2021b
	KERNEL_ARCH := mips

	KIMAGE_NAME := uImage.fit.pep.all

	KIMAGE_DUMP_NAME := Image.gz
	ifneq ($(BLD_CONFIG_RDISK_SIZE),)
		RDISK_SIZE := $(BLD_CONFIG_RDISK_SIZE)
	else
		RDISK_SIZE := 23068672
	endif

	rdisk-pkg-y := u-boot-fw-utils

	rdisk-pkg-$(BLD_CONFIG_USE_SFS) += peplink_balance_squashfs_image_build
	upgrader-pkg := balance_upgrader
else ifeq ("$(PL_BUILD_ARCH)","native-x86")
	ARCH_BITNESS := 32
	HOST_PREFIX := $(shell gcc -dumpmachine)
else ifeq ("$(PL_BUILD_ARCH)","native-x86_64")
	ARCH_BITNESS := 64
	HOST_PREFIX := $(shell gcc -dumpmachine)
else
	$(error Unknown PL_BUILD_ARCH: "$(PL_BUILD_ARCH)")
endif

ifdef TOOLCHAIN_VERSION
tool_path := $(TOOLCHAIN_BASE_PATH)/$(TOOLCHAIN_VERSION)/$(HOST_PREFIX)/bin

ifeq ($(wildcard $(tool_path)/$(HOST_PREFIX)-gcc),)
$(error Toolchain path does not have valid compiler: $(tool_path))
else
tmp_path := $(tool_path):$(PATH)
export PATH := $(tmp_path)
undefine tmp_path
endif
undefine tool_path
endif # TOOLCHAIN_VERSION

ifndef BLD_CONFIG_SYSROOT
BLD_CONFIG_SYSROOT := $(shell PATH=$(PATH) $(HOST_PREFIX)-gcc -print-sysroot)
ifeq ($BLD_CONFIG_SYSROOT,)
$(error $(HOST_PREFIX)-gcc -print-sysroot error)
endif
endif # BLD_CONFIG_SYSROOT

KERNEL_HEADERS := $(STAGING)/usr

ifeq ("$(BLD_CONFIG_KERNEL_V5_10)","y")
	kernel-pkg := linux_5_10
	KERNEL_SRC := $(PWD)/$(FETCHDIR)/linux_5_10
	IPT_VER_GT_142 := y

	ifneq ("$(BLD_CONFIG_BALANCE_KMOD)","y")
		IPT_VER_RELEASE := y
		EBT_VER_RELEASE := y
	endif
else ifeq ("$(BLD_CONFIG_KERNEL_V4_19_MTK)","y")
	kernel-pkg := linux_4_19_mtk
	KERNEL_SRC := $(PWD)/$(FETCHDIR)/linux_4_19_mtk
	IPT_VER_GT_142 := y

	ifneq ("$(BLD_CONFIG_BALANCE_KMOD)","y")
		IPT_VER_RELEASE := y
		EBT_VER_RELEASE := y
	endif
else ifeq ("$(BLD_CONFIG_KERNEL_V4_9)","y")
	kernel-pkg := linux_4_9
	KERNEL_SRC := $(PWD)/$(FETCHDIR)/linux_4_9
	IPT_VER_GT_142 := y

	ifneq ("$(BLD_CONFIG_BALANCE_KMOD)","y")
		IPT_VER_RELEASE := y
		EBT_VER_RELEASE := y
	endif
else ifeq ("$(BLD_CONFIG_KERNEL_V3_6)","y")
# linux kernel 3.6 related settings
	kernel-pkg := linux_3_6
	KERNEL_SRC := $(PWD)/$(FETCHDIR)/linux_3_6
	IPT_VER_GT_142 := y
else ifeq ($(TARGET_SERIES),native)
	kernel-pkg := linux_native
	KERNEL_SRC := /usr/src/linux
	KERNEL_HEADERS := /usr
else
# linux kernel 2.6.x related settings
	kernel-pkg := linux_2_6_28
	KERNEL_SRC := $(PWD)/$(FETCHDIR)/linux_2_6_28
	IPSET_VER_2_5_0 := y
endif

ifeq ("$(IPT_VER_RELEASE)","y")
	iptables-pkg := iptables_release
	IPTABLES_PATH := $(PWD)/$(FETCHDIR)/iptables_release
else ifeq ("$(IPT_VER_GT_142)","y")
	iptables-pkg := iptables
	IPTABLES_PATH := $(PWD)/$(FETCHDIR)/iptables
else
	iptables-pkg = iptables_1_4_2
	IPTABLES_PATH= $(PWD)/$(FETCHDIR)/iptables_1_4_2
endif

ifeq ("$(EBT_VER_RELEASE)","y")
	ebtables-pkg := ebtables_release
	EBTABLES_PATH := $(PWD)/$(FETCHDIR)/ebtables_release
else
	ebtables-pkg := ebtables
	EBTABLES_PATH := $(PWD)/$(FETCHDIR)/ebtables
endif

ifeq ("$(IPSET_VER_2_5_0)","y")
       ipset-pkg := ipset_2_5_0
else
       ipset-pkg := libmnl ipset
endif

KEXEC_DIR := var/lib/kexec
KDUMP_ROOT_DIR := tmp/kdump
UPGRADER_ROOT_DIR := tmp/upgrader
BALANCE_WEB_DIR := $(PWD)/$(FETCHDIR)/balance_web
HOST_TOOL_DEPMOD := $(HOST_TOOL_DIR)/bin/depmod

# timebomb path on rootdisk
TIMEBOMB_PATH := /etc/timebomb

# KERNEL_DIR is now obsolete, exist for backward compatibility
# new user should use KERNEL_SRC and KERNEL_HEADERS
KERNEL_DIR = $(KERNEL_SRC)

# get libm absolute path from compiler
LIBM_PATH := $(shell PATH=$(PATH) $(HOST_PREFIX)-gcc -print-file-name=libm.a)

export USE_FAKEROOT := 0
ifeq ("$(BUILD_FAKEROOT)","y")
	FAKEROOT := $(PWD)/tools/host/bin/fakeroot-ng
	FAKEROOT_STATE_FILE := $(PWD)/fakeroot_state_file
	export FAKEROOT FAKEROOT_STATE_FILE
	export USE_FAKEROOT := 1
endif

include profiles/packages.def

WLAN_DIR := $(PWD)/$(FETCHDIR)/$(wlan-pkg-y)

ifeq ("$(FW_CONFIG_KDUMP)","y")
	KERNEL_OBJ := $(PWD)/kernel.sys
else
	KERNEL_OBJ := $(KERNEL_SRC)
endif

ifeq ("$(BLD_CONFIG_USE_RAMFS)", "y")
	RAMFS_ROOT := $(TOP)/tmp/ramfs
	RAMFS_PUBLIC_KEY := keys/firmware/public.key.$(firstword $(FIRMWARE_MODEL_LIST))
endif

ifeq ("$(BLD_CONFIG_ENCRYPT_FIRMWARE)", "y")
	ENCRYPT_FW_PUBLIC_KEY := keys/rdisk/public.key.$(firstword $(FIRMWARE_MODEL_LIST))
	ENCRYPT_FW_PRIVATE_KEY := keys/rdisk/private.key.$(firstword $(FIRMWARE_MODEL_LIST))
endif 

ifeq ($(firstword $(subst _, ,$(BUILD_TARGET))),chub)
# [Bug#15462] overrides PACKAGES if target model is ContentHub packages
# TODO These chub_* models don't need any host-tools other than mksquashfs
PACKAGES = \
	$(host-tools-y) \
	$(CHUB_PCPKG_PACKAGES)
else ifeq ($(firstword $(subst _, ,$(BUILD_TARGET))),module)
# [Bug#19908] overrides PACKAGES for building downloadable modules
HAS_FIRMWARE_MODULES := y
PACKAGES = \
	$(host-tools-y) \
	$(MODULE_PACKAGES)
else
PACKAGES  = \
	$(host-tools-y) \
	$(common-lib-y)\
	$(extra-lib-y) \
	$(common-utils-y)\
	$(extra-y) \
	$(PACKAGING_TOOLS)
endif

all_packages-y = \
	$(host-tools-y) \
	$(common-lib-y) \
	$(common-utils-y) \
	$(extra-lib-y) \
	$(extra-y) \
	$(PACKAGING_TOOLS)

all_packages- = \
	$(host-tools-) \
	$(common_lib-) \
	$(common-utils-) \
	$(extra-lib-) \
	$(extra-) \
	$(wlan-pkg-) \
	$(chub-pcpkg-packages-) \
	$(rdisk-pkg-)

export $(filter BLD_CONFIG_%, $(.VARIABLES))

export \
	TARGET_OFFLOAD_SW_CFG_LIST \
	SVN_SERVER \
	STAGING \
	BALANCE_WEB_DIR \
	FIRMWARE_MODEL_LIST \
	CFG_VERSION \
	PKGVERS \
	OBJTREE \
	UPGRADER_OBJTREE \
	HAS_UPGRADER \
	HAS_CONTENTHUB_PACKAGES \
	HAS_FIRMWARE_MODULES \
	HAS_STORAGE_MGMT_TOOLS \
	HOST_TOOL_DEPMOD \
	UPGRADER_ROOT_DIR \
	RAMFS_ROOT \
	RAMFS_PUBLIC_KEY \
	LICENSE_PUBLIC_KEY \
	ENCRYPT_RDISK_KEY \
	ENCRYPT_FW_PUBLIC_KEY \
	BUILD_TARGET \
	PL_BUILD_ARCH \
	TARGET_SERIES \
	BUILD_MODEL \
	HOST_MODE \
	ARCH_BITNESS \
	BUSYBOX_CONFIG \
	IPT_VER_GT_142 \
	IPTABLES_PATH \
	EBTABLES_PATH \
	KERNEL_DIR \
	KERNEL_ARCH \
	KERNEL_SRC \
	KERNEL_OBJ \
	KERNEL_HEADERS \
	KERNEL_CONFIG_NAME \
	KDUMP_CONFIG_NAME \
	KIMAGE_NAME \
	KIMAGE_DUMP_NAME \
	KDUMP_ROOT_DIR \
	KDUMP_CONFIG_NAME \
	KEXEC_DIR \
	FW_CONFIG_KDUMP \
	EXTRA_NETWORK_CARD_DRIVERS \
	PROFILESDIR \
	PROJECT_MAKE \
	PACKAGESDIR \
	FETCHDIR \
	HELPERS \
	MNT \
	TOP \
	HOST_PREFIX \
	TOOLCHAIN_BASE_PATH \
	TOOLCHAIN_VERSION \
	WLAN_DIR \
	RDISK_SIZE \
	TIMEBOMB_PATH \
	HOST_TOOL_DIR \
	TOP_PREBUILT_EX \
	TOP_PREBUILT_IM

ifdef STAGING_DIR
	export STAGING_DIR
endif # STAGING_DIR
