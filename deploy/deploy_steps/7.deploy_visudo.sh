#!/bin/bash

function deploy_visudo() {
	git_root=$(git rev-parse --show-toplevel 2>/dev/null)
	source "${git_root}/utils/utils.sh"

	if utils_yn_prompt "Decide to disable su for the user?"; then
		utils_print_white "Continuing..."
		eval "visudo"
	else
		utils_print_red "Cancelled."
		exit 1
	fi

	utils_print_green "Configuration completed"
	exit 0
}
