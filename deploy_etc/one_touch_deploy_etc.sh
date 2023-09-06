#!/bin/bash

# paragram: new_user
# return: none
function deploy_user_files {
	local target_dir="/etc/deploy_etc"
	local git_root=$(git rev-parse --show-toplevel 2>/dev/null)

	if [[ ! -d "${target_dir}" ]]; then
		printf '%s\n' "${target_dir} not existed, create it"
		sudo su -c "mkdir ${target_dir}"
	fi

	sudo su -c "
    cp -r ${git_root}/deploy_etc/scripts/ ${target_dir}
    cp -r ${git_root}/deploy_etc/broadcast/ ${target_dir}
    "

	if [[ -d "${target_dir}/scripts" ]] && [[ -d "${target_dir}/broadcast" ]]; then
		printf '%s\n' "${target_dir} copy succeed."
		ls -al "${target_dir}"
	fi

	return 0
}

deploy_user_files
