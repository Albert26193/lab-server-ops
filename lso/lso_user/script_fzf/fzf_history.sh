#!/bin/bash

function hh {

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
