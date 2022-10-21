# shellcheck shell=bash

main.ndkms() {
	# Load configuration
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

	# TODO: handle configuration

	# Parse arguments
	local flag_module= flag_module_version=
	local raw_args=("$@")
	local -a args=()
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
			if [[ -v DKMS_COMPAT ]]; then
				util.compat_print_error $" Unknown option $arg_current"
				util.compat_show_help
			else
				util.show_help
				core.print_error "Unknown option: $arg_current"
			fi
			exit 2
			;;
		*)
			args+=("$arg_current")
			;;
		esac
	done; unset -v arg_{current,next} i raw_args

	# TODO
	# if [[ -v DEBUG ]]; then
	# 	local var=
	# 	for var in module module_version; do
	# 		local -n value="flag_$var"
	# 		printf '%s\n' "$var: $value"
	# 	done; unset -v var

	# 	local arg=
	# 	for arg in "${args[@]}"; do
	# 		printf '%s\n' "arg: $arg"
	# 	done; unset -v arg
	# fi

	# Set global variables
	local tmp_install_tree= tmp_tmp=
	if [[ -v DKMS_COMPAT ]]; then
		tmp_install_tree='/lib/module'
		tmp_tmp=${TMPDIR:-/tmp}
	else
		tmp_install_tree='/usr/lib/module'
		tmp_tmp=${TMPDIR-/tmp}
	fi
	# shellcheck disable=SC2034
	{
		declare -gr global_current_kernel=
		declare -gr global_current_os=
		declare -gr global_dkms_tree='/var/lib/dkms' # TODO
		declare -gr global_source_tree='/usr/src'
		declare -gr global_install_tree="$tmp_install_tree"
		declare -gr global_tmp="$tmp_tmp"
		declare -gr global_verbose='' # TODO
		declare -gr global_symlink_modules= # TODO
	}
	unset -v tmp_install_tree tmp_tmp

	# Handle non-flag arguments
	local action= source_tree= archive_location=
	local arg=
	for arg in "${args[@]}"; do
		# shellcheck disable=SC2053
		if [[ $arg == @(remove|autoinstall|uninstall|install|match|mktarball|unbuild|build|add|status|ldtarball) ]]; then
			if [ -n "$action" ]; then
				if [[ -v DKMS_COMPAT ]]; then
					util.compat_print_error $"I do not know how to handle $arg."
					exit 4
				else
					core.print_error "Cannot specify more than one action"
					exit 4
				fi
			fi

			action=$arg
		elif [[ -f $arg && $arg == *dkms.conf ]]; then
			source_tree=$arg
		elif [[ -d $arg && -f "$arg/dkms.conf" ]]; then
			source_tree=$arg
		elif [[ -f $arg ]]; then
			archive_location=$arg
		else
			if [[ -v DKMS_COMPAT ]]; then
				:
			else
				core.print_warn "Invalid arguments: $arg"
			fi
		fi
	done; unset -v arg

	util.get_module_and_module_version "${args[1]}" "$flag_module" "$flag_module_version"
	local module="$REPLY_MODULE"
	local module_version="$REPLY_MODULE_VERSION"

	# Run final action
	if [ -z "$action" ]; then
		if [[ -v DKMS_COMPAT ]]; then
			util.compat_print_error $"Unknown action specified: \"\"" # TODO: fix upstream?
			util.compat_show_help
			exit 0
		else
			util.show_help
			core.print_warn "Invalid argument: $arg"
			exit 1
		fi
	fi

	case $action in
	add)
		util.assert_has_module_and_moduleversion "$action" "$module" "$module_version"
		ndkms-add "${args[@]:1}"
		;;
	*)
		printf '%s\n' 'TODO' >&2 # TODO
		exit 1
	esac
}

