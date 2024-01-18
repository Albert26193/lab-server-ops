#!/bin/bash

###################################################
# description: install LSO files to /opt/lab-server-ops
#       input: none
#      return: 0: succeed | 1: failed
###################################################
function install_lso {
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

    # check branch rule
    if lso_branch_rule && lso_check_branch; then
        lso_print_green_line "branch rule check success..."
    else
        lso_print_white_line "branch rule check failed, exit now..."
        return 1
    fi

    local target_dir="/opt/lab-server-ops"

    if [[ ! -d "${target_dir}" ]]; then
        lso_print_warning_line "${target_dir} not existed, create it"
        bash -c "mkdir ${target_dir}"
    fi

    if ! lso_yn_prompt "Do you want to copy ${LSO_COLOR_GREEN}${git_root}/lso (current dir)${LSO_COLOR_RESET} to ${LSO_COLOR_GREEN}${target_dir}(install dir)${LSO_COLOR_RESET} ?"; then
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
        if ! lso_yn_prompt "${target_dir} is not empty, do you want to remove all files in it and continue?"; then
            lso_print_info_line "You should keep ${target_dir} empty. Remove all files in it manaully."
            lso_print_white_line "Exit Now..."
            return 1
        fi
        bash -c "rm -rf ${target_dir}/*"
        lso_print_green_line "${target_dir} is clear now."
    fi

    bash -c "cp -r ${git_root}/lso/lso_user ${target_dir}"
    bash -c "cp -r ${git_root}/lso/lso_utils ${target_dir}"

    if [[ -d "${target_dir}/lso_user" ]] &&
        [[ -d "${target_dir}/lso_utils" ]]; then
        lso_print_white "copy successfully, ls -al"
        lso_print_info "${target_dir}"
        lso_print_white_line " as below:"
        ls -al "${target_dir}"
    else
        printf '%s\n' "${target_dir} copy failed."
    fi

    lso_print_green_line "LSO files are deployed to ${target_dir} sucessfully. Congratulations! 🍺️"

    if [[ -e "${HOME}/.lso.env" ]]; then
        lso_print_white_line "already have ~/.lso.env"
    else
        lso_print_white_line "copy ~/.lso.env"
        cp "${git_root}/lso/files_copy/.lso.env" "${HOME}/.lso.env"
    fi

    if cat "${HOME}/.zshrc" | grep -q "/opt/lab-server-ops/lso_user/lso.sh"; then
        lso_print_white_line "already have lso script in ~/.zshrc"
        return 0
    fi

    echo -e "---------------------------------------------\n"
    lso_print_info_line "TIP: "
    lso_print_white_line "have already added below to your ~/.bashrc or ~/.zshrc:"
    lso_print_green_line "   source ${HOME}/.lso.env"
    lso_print_green_line "   source '/opt/lab-server-ops/lso_user/lso.sh'"
    lso_print_green_line "   alias "fs"="lso_fuzzy_search""
    lso_print_green_line "   alias "fj"="lso_fuzzy_jump""
    lso_print_green_line "   alias "fe"="lso_fuzzy_edit""
    lso_print_green_line "   alias "hh"="lso_fuzzy_history""
    lso_print_green_line "   alias "pon"="lso_proxy_on""
    lso_print_green_line "   alias "poff"="lso_proxy_off""

    echo '#------------------- lso -------------------
source ${HOME}/.lso.env
source "/opt/lab-server-ops/lso_user/lso.sh"

alias "fs"="lso_fuzzy_search"
alias "fj"="lso_fuzzy_jump"
alias "fe"="lso_fuzzy_edit"
alias "hh"="lso_fuzzy_history"
alias "pon"="lso_proxy_on"
alias "poff"="lso_proxy_off"
#------------------- lso -------------------' >>"${HOME}/.zshrc"

    lso_print_white_line "then, exec 'source ~/.zshrc'"

    return 0
}

install_lso
