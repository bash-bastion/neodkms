# shellcheck shell=bash

util.assert_has_module_and_moduleversion() {
	local command_name="$1"
	local module="$2"
	local module_version="$3"

	if [[ -z "$module" || -z "$module_version" ]]; then
		if util.is_compat; then
			util.compat_print_error $"Arguments <module> and <module-version> are not specified."
			util.compat_show_help_subcommand "$command_name"
			exit 1
		else
			core.print_error "Must supply module name and its version"
			util.compat_show_help_subcommand "$command_name" # TODO
			exit 1
		fi
	fi
}

util.assert_root() {
	if ((EUID != 0)); then
		if util.is_compat; then
			util.compat_print_error $"You must be root to use this command."
			exit 1
		else
			core.print_error "Must be root to use this command"
			exit 1
		fi
	fi
}
