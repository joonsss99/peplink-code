
include ../../profiles/pkgversion.lock

tools-y += MANGA_fwupgrade
tools-y += genext2fs
tools-y += module-init-tools
tools-$(BUILD_LZMA) += lzma
tools-$(BUILD_FAKEROOT) += tar
tools-$(BUILD_FAKEROOT) += fakeroot-ng

MANGA_fwupgrade-bin += genimage
MANGA_fwupgrade-bin += fiwm
genext2fs-bin += genext2fs
module-init-tools-bin += build/depmod
lzma-bin += src/lzma/lzma
tar-bin += src/tar
fakeroot-ng-bin += fakeroot-ng


install_dir = bin

INSTALL=install

##
# git

define do-git-cmd
. ../../$$PACKAGESDIR/common/common_functions ; \
	common_fetch_git $1 $($(subst .,_,$(subst -,_,$(1)))_GIT) `pwd`
endef

define do-git
phony += git-$(1)
git-$(1):
	$$(call do-git-cmd,$(1))
endef

##

tools-bin := $(foreach tool,$(tools-y),$(addprefix $(tool)/,$($(tool)-bin)))

all: install

$(foreach tool,$(tools-y),$(eval $(call do-git,$(tool))))

MANGA_fwupgrade: git-MANGA_fwupgrade
	$(MAKE) -f $(PWD)/project.mk/Makefile -C $@ empty_defconfig
	$(MAKE) -f $(PWD)/project.mk/Makefile -C $@ genimage fiwm

genext2fs/Makefile: genext2fs/configure
	cd genext2fs && ./configure

genext2fs: genext2fs/Makefile
	$(MAKE) -C $@

lzma/Makefile: lzma/configure
	cd lzma && ./configure

lzma: lzma/Makefile
	$(MAKE) -C $@

fakeroot-ng/Makefile: fakeroot-ng/configure
	cd fakeroot-ng && ./configure

fakeroot-ng: fakeroot-ng/Makefile
	$(MAKE) -C $@

tar: git-tar
	(cd $@ && if [ ! -f configure ] ; then ./bootstrap ; fi)
	(cd $@ && if [ ! -f Makefile ] ; then ./configure --prefix=`pwd`/../$(install_dir) ; fi)
	$(MAKE) -C $@

module-init-tools/configure.ac: git-module-init-tools

module-init-tools/configure: module-init-tools/configure.ac
	cd module-init-tools && autoreconf -fvi

module-init-tools/Makefile: module-init-tools/configure
	cd module-init-tools && ./configure

$(module-init-tools-bin): module-init-tools/Makefile
	$(MAKE) -C module-init-tools

module-init-tools: $(module-init-tools-bin)

install: $(tools-y)
	$(INSTALL) -d $(DESTDIR)$(install_dir)
	$(INSTALL) -p $(tools-bin) $(DESTDIR)$(install_dir)

.PHONY: all install $(tools-y) $(phony)
