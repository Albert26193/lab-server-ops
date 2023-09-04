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
    local root_dirs=(${jump_root_dirs[@]})
    local ignore_dirs=(${jump_ignore_dirs[@]})
    local exclude_args=()
    for dir in "${ignore_dirs[@]}"; do
        exclude_args+=("--exclude" "${dir}")
    done

    trap '' INT
    local target_file=$(
        printf "%s\n" "${root_dirs[@]}" |
            xargs -I {} fdfind --hidden "${exclude_args[@]}" --search-path "{}" |
            fzf --query="$1$2"
    )
    trap - INT
    echo "${target_file}"
}
