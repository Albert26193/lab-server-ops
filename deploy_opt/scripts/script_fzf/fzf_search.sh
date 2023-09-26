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
	local util_file_path="/opt/deploy_opt/scripts/script_utils/utils.sh"
	local git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
	local deploy_opt_file_path="${git_root}/deploy_opt/one_touch_deploy_opt.sh"

	if [[ ! -f "${util_file_path}" ]]; then
		printf "%s\n" "${util_file_path} do not exist."
		printf "%s\n" "execute ${deploy_opt_file_path} first."
	else
		source "${util_file_path}"
	fi

	local current_os="$(utils_check_os)"
	local fd_command=""
	local bat_command=""

	# todo: add more os to test
	if [[ "${current_os}" == "macOS" ]]; then
		fd_command="fd"
		bat_command="bat"
	elif [[ ${current_os} == "Debian" ]]; then
		fd_command="fdfind"
		bat_command="batcat"
	else
		fd_command="fd"
		bat_command="batcat"
	fi

	local fuzzy_search_dirs=()
	local fuzzy_search_ignore_dirs=(${FUZZY_SEARCH_IGNORE_DIRS[@]})
	local exclude_args=()

	for dir in "${FUZZY_SEARCH_DIRS[@]}"; do
		fuzzy_search_dirs+=("$(bash -c "echo ${dir}")")
	done

	for dir in "${fuzzy_search_ignore_dirs[@]}"; do
		dir=$(bash -c "echo ${dir}")
		exclude_args+=("--exclude" ${dir})
	done

	local preview_command=""
	if [[ "${FUZZY_SEARCH_PREVIEW}" == "true" ]]; then
		preview_command="printf 'Name: \033[1;32m %s \033[0m\n' {}; if [[ -d {} ]]; then printf 'Type: \033[1;32m %s \033[0m\n' 'Dir'; exa --tree --level 2 {}; else printf 'Type: \033[1;32m %s \033[0m\n' 'File'; head -n 50 {} | ${bat_command} --color=always --style=header,grid; fi"
	else
		preview_command="echo {};if [[ -d {} ]]; then ls -al {}; else head -n 50 {}; fi"

	fi

	#echo ${exclude_args[@]}
	local target_file=$(
		printf "%s\n" "${fuzzy_search_dirs[@]}" |
			xargs -I {} ${fd_command} --hidden ${exclude_args[@]} --search-path {} |
			fzf --query="$1$2" --ansi --preview-window 'right:40%' --preview "$preview_command"
	)
	echo "${target_file}"
	return 0
}

# fuzzy edit
function ff {
	local target_file="$(fs $1 $2)"
	local father_dir=$(dirname "${target_file}")
	local editor=$(bash -c "echo ${FUZZY_SEARCH_EDITOR}")
	cd ${father_dir} && ${editor} ${target_file}
}

# fuzzy jump
function jj {
	local target_file="$(fs $1 $2)"
	if [[ -d "${target_file}" ]]; then
		cd "${target_file}" && show_all_files
	elif [[ -f "${target_file}" ]]; then
		local father_dir=$(dirname "${target_file}")
		cd "${father_dir}" && show_all_files
	else
		#exit 1
		printf "%s\n" "exit fuzzy search ..."
	fi
}
