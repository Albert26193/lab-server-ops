#!/bin/bash

function hh {
	local util_file_path="/etc/deploy_etc/scripts/script_shell/shell_utils.sh"
	local git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
	local deploy_etc_file_path="${git_root}/deploy_etc/one_touch_deploy_etc.sh"

	if [[ ! -f "${util_file_path}" ]]; then
		printf "%s\n" "${util_file_path} do not exist."
		printf "%s\n" "execute ${deploy_etc_file_path} first."
	else
		source "${util_file_path}"
	fi

	local current_os="$(utils_check_os)"

	local history_awk_script='{
        $1=""
        $2=""
        $3=""
        print $0
    }'

	local selected_command=$(history -i | fzf | awk "${history_awk_script}" | tr -d '\n')

	printf "you have selected ${UTILS_COLOR_GREEN}%s${UTILS_COLOR_RESET}\n" "${selected_command}"

	if utils_yn_prompt "sure to execute the command?"; then
		eval "${selected_command}"
	else
		printf "${UTILS_COLOR_YELLOW}%s${UTILS_COLOR_RESET}\n" "NOT execute the command"
		if [[ "${current_os}" == "macOS" ]] && utils_yn_prompt "copy the command into your OS clip board?"; then
			eval "echo "${selected_command}" | pbcopy"
			printf "%s\n" "first line in OS clip board:"
			printf "${UTILS_COLOR_GREEN}%s${UTILS_COLOR_RESET}\n" "$(pbpaste >&1)"
			echo "just paste it"
		else
			printf "${UTILS_COLOR_YELLOW}%s${UTILS_COLOR_RESET}\n" "NOT paste the command"
		fi
	fi
}
