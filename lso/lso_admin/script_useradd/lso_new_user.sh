#!/bin/bash

###################################################
# description: add new user step by step
#       input: none
#      return: 0: success | 1: fail
###################################################
function lso_new_user() {

    local lso_root="/opt/lab-server-ops"
    local util_file_path="${lso_root}/lso_utils/utils.sh"

    if [[ ! -f "${util_file_path}" ]]; then
        printf "%s\n" "${util_file_path} do not exist. Install lab-server-ops first."
        printf "%s\n" "Exit Now..."
        return 1
    else
        source "${util_file_path}"
        lso_print_info_line "lab-server-ops utils.sh sourced."
    fi

    # Check if the script is executed as root
    if [[ "$(id -u)" -ne 0 ]]; then
        lso_print_error_line "Please run this script as root." >&2
        return 1
    fi

    # get deploy dir path
    local deploy_dir_path="${lso_root}/lso_admin/script_useradd/steps"

    # local local_test="demo"
    # source "${deploy_dir_path}/test.sh"
    # echo $local_test

    ################################### step1 add new user ################################
    lso_print_step 1
    lso_print_cyan_line "step1: add new user"

    local new_user=""
    source "${deploy_dir_path}/1.step_new_user.sh"
    if step_new_user && [[ ! -z "${new_user}" ]] && [[ -d "/home/${new_user}" ]]; then
        lso_print_info "${new_user}"
        lso_print_white_line " is added."
    else
        lso_print_white_line "Exit Now..."
        return 1
    fi

    ##################################### step2 passwd ####################################
    lso_print_step 2
    lso_print_cyan_line "step2: set passwd for ${new_user}"

    source "${deploy_dir_path}/2.step_password.sh"
    if step_password "${new_user}"; then
        lso_print_info "${new_user}"
        lso_print_white_line " has set passwd."
    else
        lso_print_white_line "Exit Now..."
        return 1
    fi

    ################################## step3 deploy visudo ################################
    lso_print_step 3
    lso_print_cyan_line "step3: change permission for ${new_user} by visudo"

    source "${deploy_dir_path}/3.step_visudo.sh"
    if deploy_visudo "${new_user}"; then
        lso_print_info "${new_user}"
        lso_print_white_line " has set permission."
    else
        lso_print_white_line "Exit Now..."
        return 1
    fi

    ################################ step4 add to group ###################################
    lso_print_step 4
    lso_print_cyan_line "step4: set groups for ${new_user}"

    source "${deploy_dir_path}/4.step_group.sh"
    if step_group "${new_user}"; then
        lso_print_info "${new_user}"
        lso_print_white_line " is added to groups."
    else
        lso_print_white_line "Exit Now..."
        return 1
    fi

    ################################### step5 deploy ssh ##################################
    lso_print_step 5
    lso_print_cyan_line "step5: generate ssh key paris for ${new_user}"

    source "${deploy_dir_path}/5.step_ssh.sh"
    if step_ssh "${new_user}"; then
        lso_print_info "${new_user}"
        lso_print_white_line "'s ssh key has generated."
    else
        lso_print_white_line "Exit Now..."
        return 1
    fi

    #################################### step6 deploy dotfiles ################################
    lso_print_step 6
    lso_print_cyan_line "step6: add dotfiles for ${new_user}"

    source "${deploy_dir_path}/6.step_dotfiles.sh"
    if step_dotfiles "${new_user}"; then
        lso_print_info "${new_user}"
        lso_print_white_line " 's dotfiles has deployed."
    else
        lso_print_white_line "Exit Now..."
        return 1
    fi

    ##################################### step7 add link ###################################
    lso_print_step 7
    lso_print_cyan_line "step7: linke ${new_user}/data to /data/${new_user}, to save space for /home"

    source "${deploy_dir_path}/7.step_link.sh"
    if step_link "${new_user}"; then
        lso_print_info "${new_user}"
        lso_print_white_line " is linked."
    else
        lso_print_white_line "Exit Now..."
        return 1
    fi

    lso_print_info_line "Congratulations! ${new_user} is added successfully.🍺️"
}

lso_new_user
