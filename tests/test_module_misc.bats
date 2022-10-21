#!/usr/bin/env bats

load './util/init.sh'

@test "is_compat null string" {
	unset -v DKMS_COMPAT
	assert value util.is_compat
}

@test "is_compat empty string" {
	export DKMS_COMPAT=
	assert value util.is_compat
}

@test "is_compat value" {
	export DKMS_COMPAT=value
	assert util.is_compat
}
