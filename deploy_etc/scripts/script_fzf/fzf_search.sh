#!/bin/bash

# fuzzy search
# input:
#       $1: search range
#       $2: ignore dirs
#       $3: search keyword
#       $4: another search keyword
# output:
#       search result
function fs {
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
	local fd_command=""

	# todo: add more os to test
	if [[ "${current_os}" == "macOS" ]]; then
		fd_command="fd"
	elif [[ ${current_os} == "Debian" ]]; then
		fd_command="fdfind"
	else
		fd_command="fd"
	fi

	local fuzzy_search_dirs=()
	local fuzzy_search_ignore_dirs=(${FUZZY_SEARCH_IGNORE_DIRS[@]})
	local exclude_args=()

	for dir in "${FUZZY_SEARCH_DIRS[@]}"; do
		fuzzy_search_dirs+=("$(eval echo "${dir}")")
	done

	for dir in "${fuzzy_search_ignore_dirs[@]}"; do
		exclude_args+=("--exclude" "${dir}")
	done

	local target_file=$(
		printf "%s\n" "${fuzzy_search_dirs[@]}" |
			xargs -I {} ${fd_command} --hidden "${exclude_args[@]}" --search-path "{}" |
			fzf --query="$1$2"
	)

	echo "${target_file}"
	return 0
}
