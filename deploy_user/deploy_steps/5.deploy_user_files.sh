#!/bin/bash

# paragram: new_user
# return: none
function deploy_user_files() {
	local util_file_path="/etc/deploy_etc/scripts/script_shell/shell_utils.sh"
	local git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
	local deploy_etc_file_path="${git_root}/deploy_etc/one_touch_deploy_etc.sh"

	if [[ ! -f "${util_file_path}" ]]; then
		printf "%s\n" "${util_file_path} do not exist."
		printf "%s\n" "execute ${deploy_etc_file_path} first."
	else
		source "${util_file_path}"
	fi

	# Check if the script is executed as root
	# if [[ "$(id -u)" -ne 0 ]]; then
	# 	utils_print_red "Please run this script as root." >&2
	# 	return 1
	# fi

	local new_user=$1

	utils_print_cyan "now, copy config files to user's home, input the username: "
	read new_user

	if ! id -u "${new_user}"; then
		utils_print_red "user '${new_user}' not exist."
		return 1
	fi

	local source_file_path="${git_root}/deploy_user/files_to_copy"
	local target_home_path="/home/${new_user}"

	local files=("template.zshrc" "template.vimrc" "zsh_download.sh" "login.sh" ".fuzzy_search_conf.yaml")

	for file in ${files[@]}; do
		sudo bash -c "cp "${source_file_path}/${file}" "${target_home_path}/${file}""
		sudo bash -c "chown "${new_user}" "${target_home_path}/${file}""
	done

	utils_print_cyan "copy files to user's dir"

	sudo bash -c "ls -al ${target_home_path}"
	return 0
}
