#!/bin/bash

# todo: some bug
preview_script='
lineno=$(echo {} | cut -d":" -f2)
file=$(echo {} | cut -d":" -f1)

printf "\033[32mFile: \033[35m%s\033[0m\n" "$file"
printf "\033[32mLine: \033[35m%s\033[0m\n" "$lineno"
printf "\n"
start=$((lineno > 4 ? lineno - 4 : 1))
end=$((lineno + 5))
sed -n "${start},${end}p" "$file" | nl -v $start | while IFS= read -r line
do
    current_lineno="$(echo "$line" | awk "{print \$1}")"
    if [[ $current_lineno -eq $lineno ]]; then
        printf "\033[1;30m\033[42m%s\033[0m\n" "$line"
    else
        printf "%s\n" "$line"
    fi
done
'

function rr {
	local fuzzy_grep_dirs=(${FUZZY_GREP_DIRS[@]})

	local ignore_dirs=(${FUZZY_GREP_IGNORE_DIRS[@]})

	local base_root="${HOME}"

	# Create include and exclude parameters for rg
	local rg_params=()
	for dir in "${fuzzy_grep_dirs[@]}"; do
		dir="$(eval echo "${dir}")"
		rg_params+=(-g "${dir}/**")
	done

	for ignore_dir in "${ignore_dirs[@]}"; do
		ignore_dir="$(eval echo "${ignore_dir}")"
		rg_params+=(-g "!${ignore_dir}")
	done

	# Switch to the base directory and run rg
	pushd "${HOME}" >/dev/null
	local target_file="$(rg "${rg_params[@]}" "" --color=always --line-number |
		fzf --ansi --preview "${preview_script}" --preview-window=up:16:wrap |
		tr ":" '\n' | tr -d " " | head -n 1)"
	popd >/dev/null

	local target_path="$(dirname "${target_file}")"
	cd "${HOME}/${target_path}"
	echo "${HOME}/${target_file}"
}
