#!/bin/bash

###################################################
# description: copy files to user's dir
#       input: $1: new_user
#      return: 0: success | 1: fail
###################################################
function step_dotfiles() {
    local new_user=$1

    # check new_user
    if [[ -z "${new_user}" ]]; then
        lso_print_red_line "new_user is empty, please check it."
        return 1
    fi

    # check new_user exist
    if ! id -u "${new_user}"; then
        lso_print_red_line "user '${new_user}' not exist."
        return 1
    fi

    # not have zsh
    if [[ -z $(which zsh) ]]; then
        lso_print_yellow_line "zsh not installed, skip."
        lso_print_yellow_line "you show install zsh manually, and change shell to zsh."
        return 1
    fi

    lso_print_cyan "ZSH(💪🏻️ Highly Recommand):"
    if lso_yn_prompt "Do you want to change shell ZSH for the ${new_user}?"; then
        sudo bash -c "chsh -s $(which zsh) ${new_user}"
        if [[ $? -ne 0 ]]; then
            lso_print_error_line "change shell ZSH failed, please check it."
            return 1
        else
            lso_print_green_line "grep in /etc/passwd as below:"
            sudo bash -c "grep -E "^${new_user}:" /etc/passwd"
        fi
    fi

    # copy files
    local source_file_path="${lso_root}/lso_admin/script_useradd/files_copy"
    local target_home_path="/home/${new_user}"
    local files=($(ls -al ${source_file_path} | tail -n +4 | awk '{print $9}'))

    if [[ ! -d "${target_home_path}" ]]; then
        lso_print_red_line "target_home_path: ${target_home_path} not exist, please check it."
        return 1
    fi

    if [[ ${#files[@]} -eq 0 ]]; then
        lso_print_red_line "files is empty, please check it."
        return 1
    fi

    if ! lso_yn_prompt "Do you want to copy files to ${target_home_path}, and load config files?"; then
        lso_print_white_line "do not copy files to ${target_home_path}, skip."
        return 1
    fi

    for file in ${files[@]}; do
        sudo bash -c "cp "${source_file_path}/${file}" "${target_home_path}/${file}""
        sudo bash -c "chown "${new_user}" "${target_home_path}/${file}""
    done

    # load config files
    sudo su - ${new_user} -c "bash ${target_home_path}/.lso_zsh.sh" 2>&1 >/dev/null

    lso_print_green_line "copy files to user's dir, ls /home/${new_user} as below:"
    sudo bash -c "ls -al ${target_home_path} | tail -n +4"

    return 0
}
