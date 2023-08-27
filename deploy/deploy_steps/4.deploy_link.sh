#!/bin/bash

# paragram: new_user
# return: none
function deploy_link() {
	git_root=$(git rev-parse --show-toplevel 2>/dev/null)
	source "${git_root}/utils/utils.sh"

	local new_user=$1

	real_data_dir="/data/${new_user}"
	symlink_dir="/home/${new_user}/data"

	if [[ ! -d "/data" ]]; then
		utils_print_green "your system do not /data mount point"
	fi

	if [[ ! -d "${real_data_dir}" ]]; then
		mkdir "${real_data_dir}" &&
			chown -R "${new_user}" "${real_data_dir}" &&
			ln -s "${real_data_dir}" "${symlink_dir}"

		utils_print_cyan "Established symbolic link, actual physical directory: ${real_data_dir}, symbolic link directory: ${symlink_dir}"
		utils_print_white "ll /data results as follows"
		eval "ls -al /data"
	else
		utils_print_red "${real_data_dir} already exists, please correct."
	fi
}
