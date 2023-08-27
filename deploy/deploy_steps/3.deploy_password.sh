#!/bin/bash

# paragram: $new_usr
# return: none
function deploy_password() {
	git_root=$(git rev-parse --show-toplevel 2>/dev/null)
	source "${git_root}/utils/utils.sh"

	local new_user=$1

	os_to_check=$(utils_check_os)
	if [[ "${os_to_check}" != "Debian" ]]; then
		passwd "${new_user}"
		print_green "add the password"
	else
		utils_print_yellow "your OS is ${os_to_check}, don't need to add password again"
	fi

}
