include $(wildcard packages/*/depend)

# action-cmd-single <action_name> <action_script> <package>
define action-cmd-single
[ -f stop-build ] && echo -e "= `date +%T` stopped" && exit 0 ; \
if [ -t 1 ] ; then echo -en "$(TITLE_START)$(3) - $(1)/$(BUILD_TARGET)/fwbuild$(TITLE_END)" ; fi ; \
if $(HELPERS)/$(2) $(3) ; then \
  echo -e "$(COLOR_GREEN)✓$(COLOR_NORMAL) `date +"%T"` Done: $(COLOR_CYAN)$(3)$(COLOR_NORMAL)"; \
else \
  echo -e "$(COLOR_RED)x$(COLOR_NORMAL) `date +%T` $(COLOR_RED)Error $(COLOR_GREEN)$(1)$(COLOR_RED) in $(COLOR_YELLOW)$(3)$(COLOR_NORMAL)" ; \
  exit 1 ; \
fi
endef

# task_dep_tmpl <pkg> <task print name> <task name> <task script> <other dependency targets>
define task_dep_tmpl
_phony += $(1)-$(3)
$(1)-$(3): $$(foreach pkgdep,$$($(1)-dep-y),$$(pkgdep)-$(3)) $(5)
	@echo -e "$(COLOR_YELLOW)⚡️$(COLOR_NORMAL)`date +%T` $(COLOR_GREEN)$(2) $(COLOR_YELLOW)$(1)$(COLOR_NORMAL): $(COLOR_BLUE)$$($(1)-dep-y)$(COLOR_NORMAL)"
	+@$$(call action-cmd-single,$(2),$(4),$(1))
endef

# task_tmpl <pkg> <task print name> <task name> <task script> <other dependency targets>
define task_tmpl
_phony += $(1)-$(3)
$(1)-$(3): $(5)
	@echo -e "$(COLOR_YELLOW)⚡️$(COLOR_NORMAL)`date +%T` $(COLOR_GREEN)$(2) $(COLOR_YELLOW)$(1)$(COLOR_NORMAL)"
	@$$(call action-cmd-single,$(2),$(4),$(1))
endef

# -fetch
$(foreach pkg,$(all_packages-y),$(eval $(call task_tmpl,$(pkg),Fetching,fetch,fetch_package.sh,)))
# -patch
$(foreach pkg,$(all_packages-y),$(eval $(call task_dep_tmpl,$(pkg),Patching,patch,patch_package.sh,)))
# -patch-chain
$(foreach pkg,$(all_packages-y),$(eval $(call task_dep_tmpl,$(pkg),Patching,patch-chain,patch_package.sh,fetch.d)))
# -prebuild
$(foreach pkg,$(all_packages-y),$(eval $(call task_dep_tmpl,$(pkg),Prebuilding,prebuild,prebuild_package.sh,)))
# -prebuild-chain
$(foreach pkg,$(all_packages-y),$(eval $(call task_dep_tmpl,$(pkg),Prebuilding,prebuild-chain,prebuild_package.sh,patch.d.c)))
# -build
$(foreach pkg,$(all_packages-y),$(eval $(call task_dep_tmpl,$(pkg),Building,build,build_package.sh,build-check)))
# -build-chain
$(foreach pkg,$(all_packages-y),$(eval $(call task_dep_tmpl,$(pkg),Building,build-chain,build_package.sh,prebuild.d.c build-check)))
# -clean
$(foreach pkg,$(all_packages-y),$(eval $(call task_tmpl,$(pkg),Cleaning,clean,clean_package.sh,)))

_phony += fetch.d patch.d prebuild.d build.d clean.d
_phony += patch.d.c prebuild.d.c build.d.c installramfs.d.c install.d.c

all.d: download-hook host-tools fetch.d patch.d.c prebuild.d.c build.d.c install.d.c

fetch.d: fetch-project-make $(addsuffix -fetch,$(PACKAGES))

patch.d: $(addsuffix -patch,$(PACKAGES))

patch.d.c: $(addsuffix -patch-chain,$(PACKAGES))

prebuild.d: $(addsuffix -prebuild,$(PACKAGES))

prebuild.d.c: hostbuild $(addsuffix -prebuild-chain,$(PACKAGES))

build.d: $(addsuffix -build,$(PACKAGES))

build.d.c: $(addsuffix -build-chain,$(PACKAGES))

# we can only execute install and installramfs in serial
installramfs.d.c: build.d.c host-tools
	@if [ "$(BLD_CONFIG_USE_RAMFS)" = "y" ];then \
		($(call action-cmd,installing ramfs,installramfs_package.sh,$(PACKAGES))) \
	fi

install.d.c: check-image-path installramfs.d.c
	@$(call action-cmd,installing,install_package.sh,$(PACKAGES))

clean.d: $(addsuffix -clean,$(PACKAGES))

