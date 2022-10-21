# shellcheck shell=bash

util.die() {
	util.compat_print_error "$2"
	exit "$1"
}

util.compat_print_error() {
	local msg=

	printf '%s' 'Error! ' >&2
	for msg; do printf '%s\n' "$msg" >&2; done
}

util.compat_print_warn() {
	local msg=

	printf '%s' 'Warning: ' >&2
	for msg; do printf '%s\n' "$msg" >&2; done
}

util.compat_print_deprecated() {
	local msg=

	printf '%s' 'Deprecated feature: ' >&2
	for msg; do printf '%s\n' "$msg" >&2; done
}

util.compat_show_help() {
	# TODO: 'dkms' issue with showing '/sbin/dkms', invocation Debian etc.
	printf '%s\n' "Usage: dkms [action] [options]
  [action]  = { add | remove | build | install | uninstall | match | autoinstall |
                mktarball | ldtarball | status }
  [options] = [-m module] [-v module-version] [-k kernel-version] [-a arch]
              [-c dkms.conf-location] [-q] [--force] [--force-version-override] [--all]
              [--templatekernel=kernel] [--directive='cli-directive=cli-value']
              [--config=kernel-.config-location] [--archive=tarball-location]
              [--kernelsourcedir=source-location]
              [--binaries-only] [--source-only] [--verbose]
              [--no-depmod] [--modprobe-on-install] [-j number] [--version]"
}

util.compat_show_help_subcommand() {
	local subcommand="$1"

	printf '%s\n' "Usage: subcommand <module>/<module-version> or
       $subcommand -m <module>/<module-version> or
       $subcommand -m <module> -v <module-version>"
}
