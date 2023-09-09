#!/bin/bash

FUZZY_SEARCH_DIRS=()
FUZZY_SEARCH_IGNORE_DIRS=()

function export_fuzzy_dirs {
	local util_file_path="/etc/deploy_etc/scripts/script_shell/shell_utils.sh"
	local git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
	local deploy_etc_file_path="${git_root}/deploy_etc/one_touch_deploy_etc.sh"

	if [[ ! -f "${util_file_path}" ]]; then
		printf "%s\n" "${util_file_path} do not exist."
		printf "%s\n" "execute ${deploy_etc_file_path} first."
		return 1
	else
		source "${util_file_path}"
	fi

	local fuzzy_search_conf="${HOME}/.fuzzy_search_conf.yaml"

	if [[ ! -f "${fuzzy_search_conf}" ]]; then
		printf "%s\n" "${fuzzy_search_conf} do not exist."
		return 1
	fi

	FUZZY_SEARCH_DIRS=($(utils_parse_yaml "${HOME}/.fuzzy_search_conf.yaml" ".fuzzy_search_dirs[]"))
	FUZZY_SEARCH_IGNORE_DIRS=($(utils_parse_yaml "${HOME}/.fuzzy_search_conf.yaml" ".fuzzy_search_ignore_dirs[]"))

}

export_fuzzy_dirs
