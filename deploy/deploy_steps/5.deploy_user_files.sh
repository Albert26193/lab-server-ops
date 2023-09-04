#!/bin/bash

# paragram: new_user
# return: none
function deploy_user_files() {
	git_root=$(git rev-parse --show-toplevel 2>/dev/null)
	source "${git_root}/utils/utils.sh"

	local new_user=$1

	utils_print_cyan "now, copyt config files to user's home, input the username: "
	read new_user

	if ! id -u "${new_user}"; then
		utils_print_red "user '${new_user}' not exist."
		return 1
	fi

	local source_file_path="${git_root}/deploy/files_to_copy"
	local target_home_path="/home/${new_user}"

	sudo su -c "
        cp ${source_file_path}/template.zshrc ${target_home_path}/template.zshrc
        cp ${source_file_path}/template.vimrc ${target_home_path}/template.vimrc
        cp ${source_file_path}/zsh_download.sh ${target_home_path}/zsh_download.sh
        cp ${source_file_path}/login.sh ${target_home_path}/login.sh
        chown ${new_user} ${target_home_path}/template.* ${target_home_path}/zsh_download.sh ${target_home_path}/login.sh"

	utils_print_cyan "copy files to user's dir"

	ls -al ${target_home_path}
	return 0
}
