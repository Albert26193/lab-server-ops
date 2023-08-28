#!/bin/bash

# paragrams: new_user
# return: none
function deploy_group() {
	git_root=$(git rev-parse --show-toplevel 2>/dev/null)
	source "${git_root}/utils/utils.sh"

	utils_print_white "Please enter group names, support continuous input, separated by spaces, such as [docker wheel sudo] etc."
	local new_groups=""
	read -a new_groups

	local new_user=$1
	for new_group in "${new_groups[@]}"; do
		# Check if the group exists, if not create it
		if ! grep -q "^${new_group}:" /etc/group; then
			utils_print_red "Group ${new_group} does not exist, please create it manually."
		fi

		# Add new user and specify group
		usermod -aG "${new_group}" "${new_user}"

		local usermod_status=$?

		if [[ ${usermod_status} -ne 0 ]]; then
			utils_print_red "Failed to add ${new_user} to group ${new_group}" >&2
			exit 1
		else
			utils_print_green "Do you decide to add ${new_user} to the ${new_group} group?"

			if utils_yn_prompt "Confirm?"; then
				utils_print_white "Continuing..."
			else
				utils_print_red "Cancelled."
				exit 1
			fi
			utils_print_green "user ${new_user} is added to ${new_group}"
		fi

	done
}
