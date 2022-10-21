# shellcheck shell=bash

ndkms-add() {
	# If archive, attempt to load
	if [ -n "" ] && [[ -n "$module" && -n "$module_version" ]]; then
		:
	elif [ -n "aa" ] && [[ -n "$module" && -n "$module_version" ]]; then
		:
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

	# Assert: Module not already loaded
	if ! util.is_module_added "$module" "$module_version"; then
		util.compat_print_error \
			$"DKMS tree already contains: $module-$module_version" \
			\ $"You cannot add the same module/version combo more than once."
		exit 3
	fi

	# Assert: Source directory must exist
	if [ ! -d "$dir" ]; then
		if util.is_compat; then
			util.compat_print_error \
				$"Could not find module source directory." \
				$"Directory: $dir does not exist."
			exit 2
		else
			core.print_error "Failed to find module source directory: $dir"
			exit 2
		fi
	fi

	# Load config
	if [ -n "$conf" ]; then # TODO: variable overrides in the wild?
		conf="$dir/dkms.conf"
	fi

	# Check conf file
	# TOOD

	# Create dkms tree structure
	# TODO

	# Run post_add script
	# TODO
}
