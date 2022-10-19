# shellcheck shell=bash

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

util.show_usage_same() {
	# TODO: if in sbin, 'dkms' won't work. Must do '/sbin/dkms', for example, and
	# show that in help menu
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
