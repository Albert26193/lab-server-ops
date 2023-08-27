#!/bin/bash

# paragrams: none
# return: new_usr
function deploy_new_user() {
	git_root=$(git rev-parse --show-toplevel 2>/dev/null)
	source "${git_root}/utils/utils.sh"

	local new_user=""
	read -p "input new user name: " new_user

	# check
	if id -u "${new_user}" >/dev/null 2>&1; then
		print_red "user: '${new_user}' already existed." >&2
		exit 1
	fi

	print_white "user's name: ${new_user}"

	if utils_yn_prompt "are you sure and ready to continue?"; then
		print_green "go on"
	else
		print_red "cancel it..."
		exit 1
	fi

	adduser ${new_user}

	local add_user_status=$?

	if [[ ${add_user_status} -ne 0 ]]; then
		print_red "Failed to add user: ${new_user}" >&2
		exit 1
	else
		print_green "user is added: ${new_user}"
	fi

	return "${new_user}"
}
