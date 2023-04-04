
pkgversion := profiles/pkgversion
pkg_lock := profiles/pkgversion.lock
pkg_release := profiles/pkgversion.release
# [Bug#15462] ContentHub packages targets and pkgversion.chub.*
contenthub_pkg_lock := profiles/pkgversion.chub.lock
contenthub_pkg_release := profiles/pkgversion.chub.release

# GIT server
GERRIT_BASE := ssh://gerrit.peplink.com:29418
export GIT_PUSH_URL := $(GERRIT_BASE)
export GIT_FETCH_URL ?= $(GERRIT_BASE)

ifneq ($(wildcard $(pkg_lock)),)

#
# firmware.model should contain:
#
# BUILD_TARGET := [balance310|balance700|m600]
#

ifeq ($(filter update release apply-release show-tagbase,$(MAKECMDGOALS)),)

V ?= 2
export V
ifneq ($(BUILDBOT),)
V := 177
endif

-include firmware.model
ifeq ($(MAKECMDGOALS),demo-web)
	BUILD_TARGET := native_x86
endif

include firmware.version
include profiles/balance.profile
include $(pkg_lock)
include Makefile.inc

# remove duplicates
define uniq
$(if $1,$(firstword $1) $(call uniq,$(filter-out $(firstword $1),$1)))
endef

ifdef PKG
PACKAGES := $(PKG)
endif
PACKAGES := $(call uniq,$(PACKAGES))

_phony += list-pkgs list-all-packages all download-hook

#default target
list-pkgs:
	@echo $(PACKAGES)

all_packages-y := $(call uniq,$(all_packages-y))
all_packages- := $(call uniq,$(all_packages-))
all_packages = $(all_packages-y) $(all_packages-)

list-all-packages:
	@echo $(all_packages) | tr " " "\n" | sort -u | xargs


all: download-hook host-tools makeopts fetch patch hostbuild prebuild build postbuild install

download-hook: .git/hooks/commit-msg

.git/hooks/commit-msg:
	wget -q -O .git/hooks/commit-msg http://gerrit.peplink.com/tools/hooks/commit-msg
	chmod 755 .git/hooks/commit-msg

staging/usr/lib:
	mkdir -p $@

images build_logs staging/usr/include $(HOST_TOOL_DIR)/bin $(OBJTREE) $(UPGRADER_OBJTREE):
	mkdir -p $@

#
# task or package specific targets
#

demo_web-pkg := \
	openssl \
	libsqlite \
	jansson \
	pepos \
	libstrutils \
	balance_feature_activation \
	balance_conf_convertor \
	balance_kmod-libs \
	libpepinfo \
	libstatus \
	libpepmodule \
	libevent \
	x509mgr \
	libpismosign \
	libcgi \
	curl \
	zlib \
	libswitch \
	freeradius-client \
	libroutedb \
	speedfusion-libs \
	wget_https \
	libportal \
	balance_ap_extender \
	iotools \
	sflowtool \
	wan_stats \
	libpam \
	pam_tacplus \
	balance_web

# This is not fully compatible with demo-web, as it requires "-std=gnu++11" support
#libvtssclient \

_phony += fetch-packages-hack demo-web
fetch-packages-hack: fetch-project-make
	@mkdir -p $(FETCHDIR)
	@$(HELPERS)/prepare_fetch.sh "balance_kmod"
	@$(HELPERS)/prepare_fetch.sh "speedfusion"

demo-web: fetch-packages-hack build-check
	@mkdir -p $(FETCHDIR)
	@$(HELPERS)/prepare_fetch.sh "$(demo_web-pkg)"
	@$(call action-cmd,prebuild demo web,prebuild_package.sh,$(demo_web-pkg))
	+@$(call action-cmd,build demo web,build_package.sh,$(demo_web-pkg))

_phony += version simple-version compiler-check
version:
	@echo $(FIRMWARE_VERSION)

simple-version:
	@echo $(VERSION).$(SUBLEVEL).$(PATCHLEVEL)

compiler-check: host-tools
	@$(HOST_PREFIX)-gcc -v > /dev/null 2>&1 || { echo "check your path to the compiler \"$(HOST_PREFIX)-gcc\"";  exit 1; }
	@which $(HOST_TOOL_DEPMOD) > /dev/null 2>&1 || { echo "HOST_TOOL_DEPMOD($(HOST_TOOL_DEPMOD)) not exists"; exit 1; }

host-bin-y := depmod fiwm genext2fs genimage peplink_sign_firmware
host-bin-$(BUILD_FAKEROOT) += fakeroot-ng tar
host-bin-$(HAS_LZMA) += lzma

_phony += host-tools host-tools-all kernel-prepare kernel-build kernel-install \
	  ramdisk-image rdisk-image upgrader-image
host-tools: fetch-project-make $(HOST_TOOL_DIR)/bin
	if [ -n "$(FWBUILD_HOST_BIN)" ] ; then \
		for tool in $(host-bin-y) ; do \
			rm -f $(HOST_TOOL_DIR)/bin/$$tool ; \
			ln -s $(FWBUILD_HOST_BIN)/$$tool $(HOST_TOOL_DIR)/bin/$$tool ; \
		done ; \
	else \
		$(MAKE) -C $(HOST_TOOL_DIR) BUILD_LZMA=$(HAS_LZMA) BUILD_FAKEROOT=$(BUILD_FAKEROOT) ; \
	fi

host-tools-all: fetch-project-make
	$(MAKE) -C $(HOST_TOOL_DIR) BUILD_LZMA=y BUILD_FAKEROOT=y DESTDIR=$(DESTDIR)
	@echo ""
	@echo "To skip building host-tools on future firmware build"
	@echo "You can set environment variable FWBUILD_HOST_BIN=$(DESTDIR)/bin"

kernel-prepare:
	@$(HELPERS)/prepare_fetch.sh "$(kernel-pkg)"
	@$(call action-cmd,kernel-pkg prebuild,prebuild_package.sh,$(kernel-pkg))

kernel-build: build-check
	+@$(call action-cmd,kernel-pkg build,build_package.sh,$(kernel-pkg))

kernel-install:
	@$(call action-cmd,kernel-pkg install,install_package.sh,$(kernel-pkg))

ramdisk-image:
	@$(call action-cmd,create ramdisk,install_package.sh,MANGA_balance_image_build)

rdisk-image:
	@$(call action-cmd,create rdisk,install_package.sh,$(rdisk-pkg-y))

upgrader-image:
	@$(call action-cmd,create upgrader image,install_package.sh,$(rdisk-pkg-y) $(upgrader-pkg))

_phony += check-image-path fetch-project-make makeopts
check-image-path: images

fetch-project-make:
	@echo -e "* $(COLOR_GREEN)fetching $(COLOR_YELLOW)project.mk$(COLOR_NORMAL)" ; \
	. $(PACKAGESDIR)/common/common_functions ; \
	common_fetch_git project.mk $(project_makefile_GIT) ./ ;

makeopts:
	$(SCRIPTS)/setup_makeopts.sh

#
# dependency targets: fetch.d, build.d, clean.d
#
include helpers/dep.mk

_phony += build-check \
	  fetch clean patch hostbuild prebuild build postbuild installramfs install \
	  stopbuild resumebuild

build-check: | compiler-check staging/usr/lib staging/usr/include $(HOST_TOOL_DIR)/bin build_logs $(OBJTREE) $(UPGRADER_OBJTREE)

#
# generic targets
#

fetch: fetch-project-make
	@$(HELPERS)/prepare_fetch.sh "$(PACKAGES)"

clean:
	@$(call action-cmd,cleaning,clean_package.sh,$(PACKAGES))

patch:
	@$(call action-cmd,patching,patch_package.sh,$(PACKAGES))

hostbuild:
	@$(call action-cmd,host build,hostbuild_package.sh,$(PACKAGES))

prebuild:
	@$(call action-cmd,prebuild,prebuild_package.sh,$(PACKAGES))

build: build-check
	+@$(call action-cmd,building,build_package.sh,$(PACKAGES))

postbuild:
	@$(call action-cmd,postbuild,postbuild_package.sh,$(PACKAGES))

installramfs:
	@if [ "$(BLD_CONFIG_USE_RAMFS)" = "y" ];then \
		($(call action-cmd,installing ramfs,installramfs_package.sh,$(PACKAGES))) \
	fi

install: host-tools check-image-path installramfs
	@$(call action-cmd,installing,install_package.sh,$(PACKAGES))

stopbuild:
	touch stop-build

resumebuild:
	rm -f stop-build
	@echo "Please run make again"

else # $(MAKECMDGOALS) is not update, release, apply-release show-tagbase

.PHONY: update release apply-release $(_phony) show-tagbase

ifneq (,$(filter show-tagbase,$(MAKECMDGOALS)))
ifeq ($(BUILD_TARGET),)
$(error BUILD_TARGET (via command line) is needed for show-tagbase)
endif
include firmware.version
endif

show-tagbase: __show-tagbase

apply-release: FORCE
	cp $(pkg_release) $(pkg_lock)

update: $(pkg_lock)

release: $(pkg_release)

# don't depend on $(pkg_lock) since we don't want this rule to
# regenerate (update) the $(pkg_lock) file
$(pkg_release): FORCE
	cp $(pkg_lock) $@

$(pkg_lock): $(pkgversion) FORCE
	@echo "Generating $@..."
	@./xfrm_gitref.rb $< $@ 1> /dev/null 2>&1

endif # $(MAKECMDGOALS) is update, release or apply-release show-tagbase

FORCE:

.PHONY: update release apply-release FORCE $(_phony)

# [Bug#15462] Generate pkgversion.chub.* based on pkgversion.*, containing
#   only packages interested for building ContentHub packages.
$(contenthub_pkg_lock): $(pkg_lock) FORCE
$(contenthub_pkg_release): $(pkg_release) FORCE
ifeq ($(firstword $(subst _, ,$(BUILD_TARGET))),chub)
$(contenthub_pkg_lock) $(contenthub_pkg_release):
	@echo "Generating $@..."
	@rm -f $@
	@$(foreach pkg,$(CHUB_PCPKG_PACKAGES),grep "^$(pkg)_" $< >> $@ || true;)
else
# Do not create pkgversion.chub.* if model is not chub_*
.PHONY: $(contenthub_pkg_lock) $(contenthub_pkg_release)
endif

else
# $(pkg_lock) not exists

# when $(pkg_lock) does not exist, we generate it, and call this Makefile
# again, but it will be calling the above targets

all := $(filter-out __all Makefile update apply-release download-hook show-tagbase,$(MAKECMDGOALS))

ifneq (,$(filter show-tagbase,$(MAKECMDGOALS)))
ifeq ($(BUILD_TARGET),)
$(error BUILD_TARGET (via command line) is needed for show-tagbase)
endif
include firmware.version

show-tagbase: __show-tagbase

endif

__all: $(pkg_lock)
	@$(MAKE) -C ./ $(all)

update: $(pkg_lock)

apply-release: FORCE
	cp $(pkg_release) $(pkg_lock)

$(all): __all
	@:

Makefile:;

$(pkg_lock): $(pkgversion) FORCE
	@echo "Generating $@..."
	@./xfrm_gitref.rb $< $@ 1> /dev/null 2>&1

download-hook: .git/hooks/commit-msg

.git/hooks/commit-msg:
	wget -q -O .git/hooks/commit-msg http://gerrit.peplink.com/tools/hooks/commit-msg
	chmod 755 .git/hooks/commit-msg

.PHONY: FORCE all update download-hook

endif # $(pkg_lock) not exist

# we expect user of show-tagbase will have BUILD_TARGET defined on command line
# and not reading from firmware.model
__show-tagbase:
	@echo -n $(__TAGNAME)$(VERSION).$(SUBLEVEL).$(PATCHLEVEL)

