#!/bin/bash

###################################################
# description: copy files to user's dir
#       input: $1: new_user
#      return: 0: success | 1: fail
###################################################
function step_dotfiles() {
    local new_user=$1

    if [[ -z "${new_user}" ]]; then
        lso_print_red_line "new_user is empty, please check it."
        return 1
    fi

    if ! id -u "${new_user}"; then
        lso_print_red_line "user '${new_user}' not exist."
        return 1
    fi

    local source_file_path="${lso_root}/lso_admin/script_useradd/files_copy"
    local target_home_path="/home/${new_user}"

    local files=("template.zshrc" "template.vimrc" "zsh_download.sh" "login.sh" ".lso.yaml")

    for file in ${files[@]}; do
        sudo bash -c "cp "${source_file_path}/${file}" "${target_home_path}/${file}""
        sudo bash -c "chown "${new_user}" "${target_home_path}/${file}""
    done

    lso_print_green_line "copy files to user's dir"

    sudo bash -c "ls -al ${target_home_path}"
    return 0
}
