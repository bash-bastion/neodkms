# shellcheck shell=bash

# config: big-print=off
task.run() {
	if [ "$var_sudo" = 'yes' ]; then
		sudo --preserve-env=DKMS_COMPAT,BASALT_PACKAGE_DIR,BASALT_GLOBAL_DATA_DIR,BASALT_GLOBAL_REPO \
			./pkg/bin/ndkms "$@"
	else
		./pkg/bin/ndkms "$@"
	fi
}

task.test() {
	bats ./tests
}
