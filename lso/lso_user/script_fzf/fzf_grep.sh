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
        printf "\033[1;30m\033[42m%s\033[0m\n" "${line}"
    else
        printf "%s\n" "$line"
    fi
done
'

function fr {
    local fuzzy_grep_dirs=(${FUZZY_GREP_DIRS[@]})

    local ignore_dirs=(${FUZZY_GREP_IGNORE_DIRS[@]})

    local base_root="${HOME}"

    # Create include and exclude parameters for rg
    local rg_params=()
    for dir in "${fuzzy_grep_dirs[@]}"; do
        dir="$(bash -c "echo ${dir}")"
        rg_params+=(-g "${dir}/**")
    done

    for ignore_dir in "${ignore_dirs[@]}"; do
        ignore_dir="$(bash -c "echo ${ignore_dir}")"
        rg_params+=(-g "!${ignore_dir}")
    done

    # Switch to the base directory and run rg
    pushd "${HOME}" >/dev/null
    local target_file="$(rg "${rg_params[@]}" "" --color=always --line-number |
        fzf --ansi --preview "${preview_script}" --preview-window=up:16:wrap |
        tr ":" '\n' | tr -d " " | head -n 1)"
    popd >/dev/null 2>&1

    echo "${HOME}/${target_file}"
}

function rr {
    local target_file="$(fr)"

    if [[ -d "${target_file}" ]]; then
        cd "${target_file}" && show_all_files
    elif [[ -f "${target_file}" ]]; then
        local father_dir=$(dirname "${target_file}")
        cd "${father_dir}"
        show_all_files
    else
        return 1
        printf "%s\n" "exit fuzzy search ..."
    fi

    return 0

}

function ee {
    local target_file="$(fr)"
    local father_dir=$(dirname "${target_file}")
    local editor=$(bash -c "echo ${FUZZY_GREP_EDITOR}")
    cd ${father_dir} && ${editor} ${target_file}
    return 0
}
