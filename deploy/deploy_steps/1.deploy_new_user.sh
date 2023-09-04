#!/bin/bash
#set -ex

# paragrams: none
# return: new_usr
new_user=""
function deploy_new_user() {
	git_root=$(git rev-parse --show-toplevel 2>/dev/null)
	source "${git_root}/utils/utils.sh"

	utils_print_gray "input new user's name: "
	read new_user

	if id -u "${new_user}" >/dev/null 2>&1; then
		utils_print_red "user: '${new_user}' already existed."
		exit 1
	fi

	utils_print_white "user's name: ${new_user}"

	if utils_yn_prompt "are you sure and ready to continue?"; then
		utils_print_green "go on"
	else
		utils_print_red "cancel it..."
		exit 1
	fi

	adduser --gecos "" "${new_user}"

	utils_print_green "${new_user} is added"
}
