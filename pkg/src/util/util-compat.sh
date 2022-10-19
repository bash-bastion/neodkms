# shellcheck shell=bash


util.compat_print_error() {
	local msg=

	printf '%s\n' 'Error! ' >&2
	for msg; do printf '%s\n' "$msg" >&2; done
}

util.compat_print_warn() {
	local msg=

	printf '%s\n' 'Warning: ' >&2
	for msg; do printf '%s\n' "$msg" >&2; done
}

util.compat_print_deprecated() {
	local msg=

	printf '%s\n' 'Deprecated feature: ' >&2
	for msg; do printf '%s\n' "$msg" >&2; done
}
