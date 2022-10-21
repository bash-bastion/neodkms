# shellcheck shell=bash

util.is_compat() {
	if [[ -v DKMS_COMPAT ]]; then :; else
		return $?
	fi
}

# TODO: are the different return values used?
util.is_module_added() {
	local module="$1"
	local module_version="$2"

	if util.is_compat; then
		if [[ -z "$module" && -z "$module_version" ]]; then
			return 1
		fi
	else
		if [[ -z "$module" || -z "$module_version" ]]; then
			return 1
		fi
	fi

	if [[ -d "$global_dkms_tree/$module/$module_version" ]]; then
		return 2
	fi

	if [[ -L $global_dkms_tree/$module/$module_version/source || -d $global_dkms_tree/$module/$module_version/source ]]; then :; else
		return $?
	fi
}
