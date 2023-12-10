#!/bin/bash
function one_touch() {
    local git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
    local util_file_path="${git_root}/utils/utils.sh"

    local deploy_opt_path="${git_root}/deploy_opt/one_touch_deploy_opt.sh"

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

    ################################# Switch to git level #################################
    deploy_dir_path="${git_root}/deploy_user/deploy_steps"

    ################################### step1 add new user ################################
    utils_print_step 1

    source "${deploy_dir_path}/1.deploy_new_user.sh"
    deploy_new_user

    echo "new user is : ${new_user}"
    ################################ step2 add to group ###################################
    utils_print_step 2

    source "${deploy_dir_path}/2.deploy_group.sh"
    deploy_group "${new_user}"

    ##################################### step3 passwd ####################################
    utils_print_step 3

    source "${deploy_dir_path}/3.deploy_password.sh"
    deploy_password "${new_user}"

    #################################### step4 add link ###################################
    utils_print_step 4

    source "${deploy_dir_path}/4.deploy_link.sh"
    deploy_link "${new_user}"

    ################################### step5 deploy files ################################
    utils_print_step 5

    source "${deploy_dir_path}/5.deploy_user_files.sh"
    deploy_user_files "${new_user}"

    ################################### step6 deploy ssh ##################################
    utils_print_step 6

    source "${deploy_dir_path}/6.deploy_ssh.sh"
    deploy_ssh "${new_user}"

    ################################## step7 deploy visudo ################################
    utils_print_step 7

    source "${deploy_dir_path}/7.deploy_visudo.sh"
    deploy_visudo "${new_user}"
}

one_touch
