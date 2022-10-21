#!/usr/bin/env bats

load './util/init.sh'

@test "works if only argument" {
	util.get_module_and_module_version 'something'


}
