# shellcheck shell=bash

helper.add_source_tree() {
	local file="$1"

	local from=
	from=$(readlink -f "$1") # TODO: Fix quoting upstream

	if ! [[ -n "$from" && -f "$from/dkms.conf" ]]; then
		if util.is_compat; then
			util.compat_print_error $"$file must contain a dkms.conf file!"
			exit 9
		else
			# TODO
			exit 9
		fi
	fi

	util.assert_root
	util.setup_kernels_arches
	local module=
	local module_version=

	if [[ -n "$force" && -d "" ]]; then
		: rm -rf
	fi

	case $from in
		"$global_source_tree/$module-$module_version")
			return
			;;
		"$global_dkms_tree/$module/$version/source")
			return
			;;
		"$dkms_tree/$module/$version/build")
			return
			;;
    esac

	mkdir -p "$global_source_tree/$module-$module_version"
	cp -fr "$from"/* "$source_tree/$module-$module-version"
}

helper.setup_kernels_arches() {
	local something="$1"

	if [[ -n "$all" && "$something" != "$status" ]]; then
		local i=0
		while read -r line; do
			# TODO
			line=${line#*/}; line=${line#*/};
			# (I would leave out the delimiters in the status output
			#  in the first place.)
			kernelver[$i]=${line%/*}
			arch[$i]=${line#*/}
		done < <(util.module_status_built "$module" "$module_version"); unset -v line i
	fi
}
