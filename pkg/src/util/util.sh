# shellcheck shell=bash

# TODO: use bash-utility die function and fully remove it bash-core
util.die() {
	core.print_error "${@:1}"
	exit 1
}

util.parse_flag() {
	unset -v REPLY; REPLY=
	local arg_current="$1"
	local arg_next="$2"

	if [[ $arg_current == *=* ]]; then
		REPLY=${arg_current#*=}
	else
		i=$((i+1)) # dynamic scope
		REPLY=$arg_next
	fi
}

util.get_module_and_module_version() {
	unset -v REPLY_MODULE{,_VERSION}; REPLY_MODULE= REPLY_MODULE_VERSION=
	local arg0="$1"
	local flag_module="$2"
	local flag_module_version="$3"

	local module{,_version}=
	if [ -n "$arg0" ]; then
		if [[ "$arg0" == */* ]]; then
			module=${arg0%%/*}
			module_version=${arg0#*/}
		else
			module=$arg0
		fi
	else
		if [ -n "$flag_module_version" ]; then
			module="$flag_module"
			module_version="$flag_module_version"
		else
			module="${flag_module%%/*}"
			module_version="${flag_module#*/}"
		fi
	fi

	REPLY_MODULE=$module
	REPLY_MODULE_VERSION=$module_version
}

util.show_help() {
	printf '%s\n' "ndkms <action> <options ...>

ACTIONS:

add
  Add

remove
  Remove

build
  Build

install
  Install
"
}
