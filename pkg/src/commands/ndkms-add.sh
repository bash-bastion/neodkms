# shellcheck shell=bash

ndkms-add() {
	if [ "$flag_all" = 'yes' ]; then
		util.compat_print_error $"The action $action does not support the --all parameter."
		die 5
	fi

	if ! [[ -w "$global_dkms_tree" ]]; then
		util.compat_print_error $"No write access to DKMS tree at $global_dkms_tree"
		exit 1
	fi

	if ! (( EUID == 0 )); then
		util.compat_print_error $"You must be root to use this command."
		exit 1
	fi

	local dir="$global_source_tree/$module-$module_version"
	if [ ! -d "$dir" ]; then
		if [[ -v DKMS_COMPAT ]]; then
			util.compat_print_error \
				$"Could not find module source directory." \
				$"Directory: $dir does not exist."
			exit 2
		else
			core.print_error "Failed to find module source directory: $dir"
			exit 2
		fi
	fi
}
