#!/bin/bash

###################################################
# description: install LSO files to /opt/lab-server-ops
#       input: none
#      return: 0: succeed | 1: failed
###################################################
function uninstall_lso {
    local git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
    local util_file_path="${git_root}/utils/utils.sh"

    if [[ ! -f "${util_file_path}" ]]; then
        printf "%s\n" "${util_file_path} do not exist."
        printf "%s\n" "Exit Now..."
        return 1
    else
        source "${util_file_path}"
    fi

    # Check if the script is executed as root
    if [[ "$(id -u)" -ne 0 ]]; then
        lso_print_error_line "Please run this script as root." >&2
        return 1
    fi

    local target_dir="/opt/lab-server-ops"

    if [[ ! -d "${target_dir}" ]]; then
        lso_print_warning_line "${target_dir} not existed, create it"
        bash -c "mkdir ${target_dir}"
    fi

    if ! lso_yn_prompt "Do you want to REMOVE ${LSO_COLOR_GREEN}${target_dir}(install dir)${LSO_COLOR_RESET} ?"; then
        lso_print_white_line "Exit Now..."
        return 1
    fi

    if [[ ! -d "${git_root}/lso" ]]; then
        lso_print_error_line "${git_root}/lso not existed, please check."
        return 1
    fi

    if [[ $(ls -A "${target_dir}") ]]; then
        lso_print_green_line "ls -al ${target_dir} as below:"
        ls -al "${target_dir}"
        lso_print_warning_line "You should keep ${target_dir} empty."
        if ! lso_yn_prompt "${target_dir} is not empty, do you want to remove all files in it?"; then
            lso_print_white_line "Exit Now..."
            return 1
        fi
        bash -c "rm -rf ${target_dir}/*"
        lso_print_green_line "${target_dir} is clear now."
    fi

    lso_print_green_line "LSO files are cleared sucessfully. You have uninstalled it!🔧️"
    return 0
}

uninstall_lso
