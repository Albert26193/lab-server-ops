#!/bin/bash

###################################################
# description: fuzzy search
#       input: $1: search range
#       input: $2: ignore dirs
#       input: $3: search keyword
#       input: $4: another search keywordFs
#        echo: matched file(search result)
#      return: 0: success | 1: fail
###################################################
function lso_fuzzy_search {
    # source utils.sh
    local lso_root="/opt/lab-server-ops"
    local util_file_path="${lso_root}/lso_utils/utils.sh"

    if [[ ! -f "${util_file_path}" ]]; then
        printf "%s\n" "${util_file_path} do not exist. Install lab-server-ops first."
        printf "%s\n" "Exit Now..."
        return 1
    else
        source "${util_file_path}"
    fi

    # add fzf search range
    local current_os="$(lso_check_os)"
    local fd_command=""
    local bat_command=""

    case "${current_os}" in
    "macOS")
        fd_command="fd"
        bat_command="bat"
        ;;
    "Debian" | "Ubuntu" | "Raspbian")
        fd_command="fdfind"
        bat_command="batcat"
        ;;
    *)
        fd_command="fd"
        bat_command="batcat"
        ;;
    esac

    # variable load
    local lso_var_file="${HOME}/.lso.env"

    if [[ -z "${lso_search_dirs}" ]] || [[ -z "${lso_search_preview}" ]] || [[ -z "${lso_editor}" ]]; then
        lso_print_red_line "some of env variable is empty, please check it in "${HOME}/.lso.env"."
        lso_print_white_line "Now, try to source ${lso_var_file} ..."
        if [[ -f "${lso_var_file}" ]]; then
            source "${lso_var_file}"
        else
            lso_print_red_line "${lso_var_file} not exist, please check it."
            return 1
        fi
    fi

    # for dir in "${lso_search_dirs[@]}"; do
    #     search_dirs+=("$(bash -c "echo ${dir}")")
    # done

    local exclude_args=()
    for dir in "${lso_search_ignore_dirs[@]}"; do
        dir=$(bash -c "echo ${dir}")
        exclude_args+=("--exclude" ${dir})
    done

    local preview_command=""
    if [[ "${lso_search_preview}" == "true" ]]; then
        preview_command="printf 'Name: \033[1;32m %s \033[0m\n' {}; if [[ -d {} ]]; then printf 'Type: \033[1;32m %s \033[0m\n' 'Dir'; exa --tree --level 2 {}; else printf 'Type: \033[1;32m %s \033[0m\n' 'File'; head -n 50 {} | ${bat_command} --color=always --style=header,grid; fi"
    else
        preview_command="echo {};if [[ -d {} ]]; then ls -al {}; else head -n 50 {}; fi"

    fi

    local target_file=$(
        printf "%s\n" "${lso_search_dirs[@]}" |
            xargs -I {} ${fd_command} --hidden ${exclude_args[@]} --search-path {} |
            fzf --query="$1$2" --ansi --preview-window 'right:40%' --preview "$preview_command"
    )

    if [[ -z "${target_file}" ]]; then
        echo ""
        echo "exit fuzzy search ..." >&2
        return 1
    else
        echo "${target_file}"
    fi

    return 0
}

###################################################
# description: edit file by fuzzy search result
#       input: $1: search keyword 1
#       input: $2: search keyword 2
#      return: 0: success | 1: fail
###################################################
function lso_fuzzy_edit {
    local target_file="$(lso_fuzzy_search $1 $2)"
    local father_dir=$(dirname "${target_file}")

    if [[ -z "${target_file}" ]]; then
        return 1
    fi

    if [[ -z "${lso_editor}" ]]; then
        lso_print_red_line "env '$lso_editor' is empty, please check it."
        return 1
    fi

    local editor=$(bash -c "echo ${lso_editor}")
    cd ${father_dir} && ${editor} ${target_file}

    if [[ $? -eq 0 ]]; then
        return 1
    fi

    return 0
}

###################################################
# description: show files in current directory
#       input: none
#      return: 0: success | 1: fail
###################################################
function lso_show_files {
    local currentPath=$(pwd)
    local normalFileNum=$(ls -al | tail -n +4 | grep "^-" | wc -l | tr -d ' ')
    local dirFileNum=$(ls -al | tail -n +4 | grep "^d" | wc -l | tr -d ' ')
    local totalNum=$((${normalFileNum} + ${dirFileNum}))

    printf "\033[1;30m\033[44mjump to: \033[1;30m\033[42m%s\033[0m\n" "${currentPath}"
    printf "\033[1;30m\033[44mfile count: \033[1;30m\033[42m%s\033[0m\n" "${totalNum}"
    printf "%s\n" "============="

    if [[ ${totalNum} -le 35 ]]; then
        ls -al | tail -n +2
    elif [[ ${totalNum} -ge 101 ]]; then
        echo "files in current directory is more than 100"
    else
        ls -a
    fi
}

###################################################
# description: jump to dir by fuzzy search result
#       input: $1: search keyword 1
#       input: $2: search keyword 2
#      return: 0: success | 1: fail
###################################################
function lso_fuzzy_jump {
    local target_file="$(lso_fuzzy_search $1 $2)"
    if [[ -d "${target_file}" ]]; then
        cd "${target_file}" && lso_show_files
    elif [[ -f "${target_file}" ]]; then
        local father_dir=$(dirname "${target_file}")
        cd "${father_dir}" && lso_show_files
    else
        return 1
    fi

    return 0
}
