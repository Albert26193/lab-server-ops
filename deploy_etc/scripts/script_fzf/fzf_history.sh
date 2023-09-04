#!/bin/bash

# 获取 Bash 历史记录并使用 fzf 进行交互式选择
function hh {
    local history_awk_script='{
        $1=""
        $2=""
        $3=""
        print $0
    }'

    local selected_command=$(history -i | fzf | awk "${history_awk_script}" | tr -d '\n')
    printf "you have selected ${MY_UTILS_COLOR_GREEN}%s${MY_UTILS_COLOR_RESET}\n" "${selected_command}"

    if yn_prompt "sure to execute the command?"; then
        eval "${selected_command}"
    else
        printf "${MY_UTILS_COLOR_YELLOW}%s${MY_UTILS_COLOR_RESET}\n"  "NOT execute the command"
        if yn_prompt "copy the command into your OS X clip board?"; then
            eval "echo "${selected_command}" | pbcopy"
            printf "%s\n" "first line in OS X clip board:"
            printf "${MY_UTILS_COLOR_GREEN}%s${MY_UTILS_COLOR_RESET}\n" "$(pbpaste >&1)"
            echo "just paste it"
        else
            printf "${MY_UTILS_COLOR_YELLOW}%s${MY_UTILS_COLOR_RESET}\n"  "NOT paste the command"
        fi
    fi
}
