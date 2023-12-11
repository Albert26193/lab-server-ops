#!/bin/bash

###################################################
# description: fuzzy history search
#       input: none
#      return: matched command in history
###################################################
function lso_fuzzy_history() {
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

    local current_os="$(lso_check_os)"
    local history_awk_script='{
        $1=""
        $2=""
        $3=""
        print $0
    }'

    local selected_command=$(history -i | fzf | awk "${history_awk_script}" | tr -d '\n' | awk '{gsub(/^ */, ""); print}')

    lso_print_white "you have selected:"
    lso_print_info_line "${selected_command}"

    if lso_yn_prompt "sure to execute the command?"; then
        eval "${selected_command}"
    else
        printf "${LSO_COLOR_YELLOW}%s${LSO_COLOR_RESET}\n" "NOT execute the command"
        if [[ "${current_os}" == "macOS" ]] && [[ "$(which pbcopy)" ]] && lso_yn_prompt "copy the command into your OS clip board?"; then
            eval "echo "${selected_command}" | pbcopy"
            printf "%s\n" "first line in OS clip board:"
            printf "${LSO_COLOR_GREEN}%s${LSO_COLOR_RESET}\n" "$(pbpaste >&1)"
            echo "just paste it"
        else
            printf "${LSO_COLOR_YELLOW}%s${LSO_COLOR_RESET}\n" "Exit Now..."
        fi
    fi
}
