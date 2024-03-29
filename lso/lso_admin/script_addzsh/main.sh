#!/bin/bash

###################################################
# description: copy files to user's dir
#       input: $1: target_user
#      return: 0: success | 1: fail
###################################################
function lso_addzsh() {

    # Check if the script is sourced
    local lso_root="/opt/lab-server-ops"
    local util_file_path="${lso_root}/lso_utils/utils.sh"

    if [[ ! -f "${util_file_path}" ]]; then
        printf "%s\n" "${util_file_path} do not exist. Install lab-server-ops first."
        printf "%s\n" "Exit Now..."
        return 1
    else
        source "${util_file_path}"
        lso_print_green_line "lab-server-ops utils.sh sourced."
    fi

    # Check if the script is executed as root
    if [[ "$(id -u)" -ne 0 ]]; then
        lso_print_error_line "Please run this script as root." >&2
        return 1
    fi

    local target_user=""
    lso_print_cyan_line "input target_user: "
    read target_user

    if id -u "${target_user}" >/dev/null 2>&1; then
        lso_print_green_line "target_user: ${target_user}"
    else
        lso_print_red_line "user: '${target_user}' not exist."
        return 1
    fi

    # check target_user
    if [[ -z "${target_user}" ]]; then
        lso_print_red_line "target_user is empty, please check it."
        lso_print_red_line "you should input target_user as param, like 'bash lso_add_zsh.sh [target_user]'."
        return 1
    fi

    # check target_user exist
    if ! id -u "${target_user}"; then
        lso_print_red_line "user '${target_user}' not exist."
        return 1
    fi

    # not have zsh
    if [[ -z $(which zsh) ]]; then
        lso_print_yellow_line "zsh not installed, skip."
        lso_print_yellow_line "you show install zsh manually, and change shell to zsh."
        return 1
    fi

    lso_print_cyan "ZSH(💪🏻️ Highly Recommand):"
    if lso_yn_prompt "Do you want to change shell ZSH for the ${LSO_COLOR_GREEN}${target_user}${LSO_COLOR_RESET}?"; then
        sudo bash -c "chsh -s $(which zsh) ${target_user}"
        if [[ $? -ne 0 ]]; then
            lso_print_error_line "change shell ZSH failed, please check it."
            return 1
        else
            lso_print_green_line "grep in /etc/passwd as below:"
            sudo bash -c "grep -E "^${target_user}:" /etc/passwd"
        fi
    fi

    # copy files
    local source_file_path="${lso_root}/lso_admin/script_addzsh/files_copy"
    local target_home_path="/home/${target_user}"
    local files=($(ls -al ${source_file_path} | tail -n +4 | awk '{print $9}'))

    if [[ ! -d "${target_home_path}" ]]; then
        lso_print_red_line "target_home_path: ${target_home_path} not exist, please check it."
        return 1
    fi

    if [[ ${#files[@]} -eq 0 ]]; then
        lso_print_red_line "files is empty, please check it."
        return 1
    fi

    if ! lso_yn_prompt "Do you want to copy files to ${LSO_COLOR_GREEN}${target_home_path}${LSO_COLOR_RESET}, and load config files?"; then
        lso_print_white_line "do not copy files to ${target_home_path}, skip."
        return 1
    fi

    for file in ${files[@]}; do
        sudo bash -c "cp "${source_file_path}/${file}" "${target_home_path}/${file}""
        sudo bash -c "chown "${target_user}:${target_user}" "${target_home_path}/${file}""
    done

    # load config files
    sudo su - ${target_user} -c "bash ${target_home_path}/lso_zsh.sh"

    if [[ ! -f "${target_home_path}/.oh-my-zsh/oh-my-zsh.sh" ]] ||
        [[ ! -d "${target_home_path}/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]] ||
        [[ ! -d "${target_home_path}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
        lso_print_red_line "load config files failed, cd to ${target_home_path} and run 'lso_zsh.sh' manually."
        return 1
    else
        lso_print_info_line "load config files successfully."
    fi

    lso_print_green_line "copy files to user's dir, ls ${target_home_path} as below:"
    sudo bash -c "ls -al ${target_home_path} | tail -n +4"

    return 0
}

lso_addzsh
