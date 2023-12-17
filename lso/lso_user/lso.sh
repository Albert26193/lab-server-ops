#!/bin/bash

###################################################
# description: source execute files
#       input: none
#      return: 0: success | 1: fail
###################################################
function lso_source_user() {

    # Check if the script is sourced
    local lso_root="/opt/lab-server-ops"
    local user_dir="${lso_root}/lso_user"

    if [[ ! -d "${user_dir}" ]]; then
        printf "%s\n" "${user_dir} do not exist. Install lab-server-ops first."
        printf "%s\n" "Exit Now..."
        return 1
    fi

    # Check if the script is executed as root
    # if [[ "$(id -u)" -ne 0 ]]; then
    #     printf "%s\n" "Please run this script as root." >&2
    #     return 1
    # fi

    source "${user_dir}/script_fzf/fzf_history.sh"
    source "${user_dir}/script_fzf/fzf_search.sh"
    source "${user_dir}/script_out/out.sh"
}

lso_source_user
