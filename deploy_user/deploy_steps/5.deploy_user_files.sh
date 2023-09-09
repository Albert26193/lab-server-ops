#!/bin/bash

# paragram: new_user
# return: none
function deploy_user_files() {
	git_root=$(git rev-parse --show-toplevel 2>/dev/null)
	source "${git_root}/utils/utils.sh"

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

	sudo bash -c "
	for file in ${files[@]}; do
		cp ${source_file_path}/${file} ${target_home_path}/${file}
		chown ${new_user} ${target_home_path}/${file}
	done"

	utils_print_cyan "copy files to user's dir"

	sudo bash -c "ls -al ${target_home_path}"
	return 0
}
