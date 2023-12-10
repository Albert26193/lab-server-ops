#!/bin/bash

###################################################
# description: link /data/${new_user} to /home/${new_user}/data
#      return: 0: success | 1: fail
###################################################
function step_link() {
    local new_user=$1

    local real_data_dir="/data/${new_user}"
    local symlink_dir="/home/${new_user}/data"

    if [[ -z "${new_user}" ]]; then
        lso_print_red_line "new_user is empty, please check it."
        return 1
    fi

    if [[ ! -d "/data" ]]; then
        lso_print_red_line "your system do not /data mount point"
        if lso_yn_prompt "do you want to create it?"; then
            mkdir "/data"
            lso_print_green_line "created /data"
        else
            return 1
        fi
    fi

    if [[ ! -d "${real_data_dir}" ]]; then
        mkdir -p "${real_data_dir}" &&
            chown -R "${new_user}" "${real_data_dir}" &&
            ln -s "${real_data_dir}" "${symlink_dir}"

        lso_print_green_line "established symbolic link:"
        lso_print_green_line "actual physical directory: ${real_data_dir}, symbolic link directory: ${symlink_dir}"
        lso_print_white_line "ll /data results as follows: "
        eval "ls -al /data"
    else
        lso_print_red_line "${real_data_dir} already exists, please correct."
    fi

    return 0
}
