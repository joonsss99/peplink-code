#!/bin/bash

PACKAGES=$1

. ${HELPERS}/functions

p_fetch() {
	if [ -t 1 ] ; then
		echo -en "${TITLE_START}$1 - fetch/${BUILD_TARGET}/fwbuild${TITLE_END}"
	fi
	echo -e "* ${COLOR_LGREEN}fetching ${COLOR_LYELLOW}$1${COLOR_NORMAL}"
	$HELPERS/fetch_package.sh "$1"
}

# export p_fetch function for parallel command
export -f p_fetch

if ! which parallel > /dev/null; then
	# No parallel support, fetch packages one by one
	echo -e "\nFetching packages ${COLOR_LYELLOW}one by one${COLOR_NORMAL}... you can speed up by installing \"parallel\"\n"
	for i in ${PACKAGES}; do
		p_fetch ${i} || exit 1
	done
else
	# Fetch packages in parallel
	echo -e "\nFetching packages in ${COLOR_LGREEN}parallel${COLOR_NORMAL}...\n"
	parallel --halt 1 p_fetch ::: ${PACKAGES}
fi
