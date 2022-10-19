# shellcheck shell=bash

main.ndkms() {
	core.shopt_push -s nullglob
	local files=(/etc/dkms/framework.conf /etc/dkms/framework.conf.d/*)
	core.shopt_pop

	for f in "${files[@]}"; do
		if [ "${f##*.}" = 'conf' ]; then
			# shellcheck disable=SC1090
			source "$f" >/dev/null
		else
			core.print_warn "File ignored (must end in .conf): $f"
		fi
	done; unset -v f
	unset -v files

	local -a args=()
	local flag_module= flag_module_version=

	local raw_args=("$@")
	local i=
	for ((i=0; i < $#; ++i)); do
		local arg_current="${raw_args[i]}"
		local arg_next="${raw_args[i+1]}"

		case $arg_current in
		--module*|-m)
			util.parse_flag "$arg_current" "$arg_next"
			flag_module=$REPLY
			;;
		-v)
			util.parse_flag "$arg_current" "$arg_next"
			flag_module_version=$REPLY
			;;
		--kernelver*|-k)
			;;
		--templatekernel*)
			;;
		-c)
			;;
		--quiet|-q)
			;;
		--version|-V)
			;;
		--no-initrd)
			;;
		--no-clean-kernel)
			;;
		--no-prepare-kernel)
			;;
		--binaries-only)
			;;
		--source-only)
			;;
		--force)
			;;
		--force-version-override)
			;;
		--all)
			;;
		--verbose)
			;;
		--rpm_safe_upgrade)
			;;
		--dkmstree*)
			;;
		--sourcetree*)
			;;
		--installtree*)
			;;
		--symlink-modules)
			;;
		--config*)
			;;
		--archive*)
			;;
		--arch*|-a)
			;;
		--kernelsourcedir*)
			;;
		--directive*)
			;;
		--no-depmod)
			;;
		--modprobe-on-install)
			;;
		--debug)
			;;
		-j)
			;;
		-*)
			util.show_usage_same
			core.print_error "Unknown option: $arg_current"
			exit 2
			;;
		*)
			args+=("$arg_current")
			;;
		esac
	done; unset -v arg_{current,next} i raw_args

	if [[ -v DEBUG ]]; then
		local var=
		for var in module module_version; do
			local -n value="flag_$var"
			printf '%s\n' "$var: $value"
		done; unset -v var

		local arg=
		for arg in "${args[@]}"; do
			printf '%s\n' "arg: $arg"
		done; unset -v arg
	fi

	local glob='@(remove|autoinstall|uninstall|install|match|mktarball|unbuild|build|add|status|ldtarball)'
	# shellcheck disable=SC2053
	if [[ "${args[0]}" == $glob && "${args[1]}" == $glob ]]; then
		# imo this check is kinda dumb, but we want to give the exact same responses
		core.print_error "Cannot specify more than one action"
		exit 4
	fi

	dkms_tree='/var/lib/dkms'

	local action="${args[0]}"
	local arg
	for arg in "${args[@]:1}"; do
		if [[ -f $arg && $arg == *dkms.conf ]]; then
			"ndkms-$action" "$arg"
		elif [[ -d $arg && -f "$arg/dkms.conf" ]]; then
			: 'source tree'
		elif [[ -f $arg ]]; then
			: 'archive'
		else
			if [[ -v DKMS_COMPAT ]]; then
				util.compat_print_warn $"I do not know how to handle $arg."
			else
				core.print_warn "I do not know how to handle $arg"

			fi
		fi
	done; unset -v arg
}

