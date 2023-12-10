#!/bin/bash
function lso_newuser() {
    local lso_root="/opt/lso"
    local util_file_path="${lso_root}/lso_utils/utils.sh"

    if [[ ! -f "${util_file_path}" ]]; then
        printf "%s\n" "${util_file_path} do not exist. Install LSO first."
        printf "%s\n" "Exit Now..."
        return 1
    else
        source "${util_file_path}"
        lso_print_info_line "LSO utils.sh sourced."
    fi

    # Check if the script is executed as root
    if [[ "$(id -u)" -ne 0 ]]; then
        lso_print_error_line "Please run this script as root." >&2
        return 1
    fi

    # get deploy dir path
    deploy_dir_path="${lso_root}/lso_admin/script_adduser/steps"

    # local_test=""
    # source "${deploy_dir_path}/test.sh"
    # echo $local_test

    ################################### step1 add new user ################################
    lso_print_step 1

    source "${deploy_dir_path}/1.step_new_user.sh"
    if step_new_user; then
        lso_print_info "${new_user}"
        lso_print_white_line " is added."
    else
        return 1
    fi

    ################################ step2 add to group ###################################
    lso_print_step 2

    source "${deploy_dir_path}/2.step_group.sh"
    if step_group "${new_user}"; then
        lso_print_info "${new_user}"
        lso_print_white_line " is added to groups."
    else
        return 1
    fi

    return 1
    ##################################### step3 passwd ####################################
    lso_print_step 3

    source "${deploy_dir_path}/3.deploy_password.sh"
    deploy_password "${new_user}"

    #################################### step4 add link ###################################
    lso_print_step 4

    source "${deploy_dir_path}/4.deploy_link.sh"
    deploy_link "${new_user}"

    ################################### step5 deploy files ################################
    lso_print_step 5

    source "${deploy_dir_path}/5.deploy_user_files.sh"
    deploy_user_files "${new_user}"

    ################################### step6 deploy ssh ##################################
    lso_print_step 6

    source "${deploy_dir_path}/6.deploy_ssh.sh"
    deploy_ssh "${new_user}"

    ################################## step7 deploy visudo ################################
    lso_print_step 7

    source "${deploy_dir_path}/7.deploy_visudo.sh"
    deploy_visudo "${new_user}"
}

lso_newuser
