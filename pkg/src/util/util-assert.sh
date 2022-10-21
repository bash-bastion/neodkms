# shellcheck shell=bash

util.assert_has_module_and_moduleversion() {
	local command_name="$1"
	local module="$2"
	local module_version="$3"

	if [[ -z "$module" || -z "$module_version" ]]; then
		if [[ -v DKMS_COMPAT ]]; then
			util.compat_print_error $"Arguments <module> and <module-version> are not specified."
			util.compat_show_help_subcommand "$command_name"
		else
			core.print_error "Must supply module name and its version"
			util.compat_show_help_subcommand "$command_name" # TODO
		fi
	fi
}
