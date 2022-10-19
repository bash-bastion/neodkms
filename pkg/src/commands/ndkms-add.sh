# shellcheck shell=bash

ndkms-add() {
	if [ "$flag_all" = 'yes' ]; then
		util.compat_print_error $"The action $action does not support the --all parameter."
		die 5
	fi

	if ! [[ $(id -u) = 0 ]]; then # TODO: EUID
		util.compat_print_error $"You must be root to use this command."
		exit 1
	fi

	if ! [[ -w "$dkms_tree" ]]; then
		util.compat_print_error $"No write access to DKMS tree at $dkms_tree"
		exit 1
	fi
}
