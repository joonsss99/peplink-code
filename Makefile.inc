# vim: set syntax=make:

COLOR_RED	:= \\033[31m
COLOR_GREEN	:= \\033[32m
COLOR_YELLOW	:= \\033[33m
COLOR_BLUE	:= \\033[34m
COLOR_MAGENTA	:= \\033[35m
COLOR_CYAN	:= \\033[36m
COLOR_BRED 	:= \\033[1;31m
COLOR_BGREEN 	:= \\033[1;32m
COLOR_BYELLOW	:= \\033[1;33m
COLOR_NORMAL 	:= \\033[0;39m

TITLE_START := \\033]2;
TITLE_END := \\007

# action-cmd <action_name> <action_script> <package_list>
define action-cmd
total=`echo "$(3)" | wc -w` ; \
current=0 ; \
for package in $(3); do \
  [ -f stop-build ] && echo "firmware build stopped" && exit 0; \
  ((current += 1)) ; \
  if [ -t 1 ] ; then echo -en "$(TITLE_START)($${current}/$${total}) $$package - $(1)/$(BUILD_TARGET)/fwbuild$(TITLE_END)" ; fi ; \
  echo -e "* `date +%T` $(COLOR_GREEN)$(1) ($${current}/$${total}) $(COLOR_YELLOW)$$package$(COLOR_NORMAL)" ; \
  if ! $(HELPERS)/$(2) $$package ; then \
    echo -e "$(COLOR_RED)x$(COLOR_NORMAL) `date +%T` $(COLOR_RED)Error $(COLOR_GREEN)$(1)$(COLOR_RED) in $(COLOR_YELLOW)$$package$(COLOR_NORMAL)" ; \
    exit 1; fi \
done
endef

