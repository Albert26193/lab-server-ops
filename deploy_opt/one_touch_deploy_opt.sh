#!/bin/bash

# paragram: new_user
# return: none
function deploy_user_files {
	local target_dir="/opt/deploy_opt"
	local git_root=$(git rev-parse --show-toplevel 2>/dev/null)

	if [[ ! -d "${target_dir}" ]]; then
		printf '%s\n' "${target_dir} not existed, create it"
		sudo bash -c "mkdir ${target_dir}"
	fi

	sudo bash -c "cp -r ${git_root}/deploy_opt/scripts ${target_dir}"
	sudo bash -c "cp -r ${git_root}/deploy_opt/broadcast ${target_dir}"

	if [[ -d "${target_dir}/scripts" ]] && [[ -d "${target_dir}/broadcast" ]]; then
		printf '%s\n' "${target_dir} copy succeed."
		ls -al "${target_dir}"
	else
		printf '%s\n' "${target_dir} copy failed."
	fi

	return 0
}

deploy_user_files
