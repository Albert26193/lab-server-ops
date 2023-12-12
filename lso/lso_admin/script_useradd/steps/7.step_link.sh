#!/bin/bash

###################################################
# description: link /data/${new_user} to /home/${new_user}/data
#       input: $1: new_user
#      return: 0: success | 1: fail
###################################################
function step_link() {
    local new_user=$1

    local real_data_dir="/data/${new_user}"
    local symlink_dir="/home/${new_user}/data"

    local data_mount_point="$(df -h | grep -E "/data$" | awk '{print $1}')"
    local home_mount_point="$(df -h | grep -E "/home$" | awk '{print $1}')"

    # new_user is empty
    if [[ -z "${new_user}" ]]; then
        lso_print_red_line "new_user is empty, please check it."
        return 1
    fi

    # have ho /data dir
    if [[ ! -d "/data" ]]; then
        lso_print_yellow_line "your system do not /data dir. no need to link."
        return 1
    fi

    # have the same mount point
    if [[ "${data_mount_point}" == "${home_mount_point}" ]]; then
        lso_print_yellow_line "the /data and /home are in the same partition, no need to link."
        return 1
    else
        lso_print_white_line "/data mount point: ${data_mount_point}"
        lso_print_white_line "/home mount point: ${home_mount_point}"
    fi

    # /data/${new_user} already exists
    if [[ -d "${real_data_dir}" ]]; then
        lso_print_red_line "${real_data_dir} already exists."
        if lso_yn_prompt "Do you want to delete ${real_data_dir}?"; then
            rm -rf "${real_data_dir}"
            lso_print_green_line "delete ${real_data_dir} successfully."
        else
            lso_print_white_line "abort delete ${real_data_dir}."
            return 1
        fi
    fi

    # link /data/${new_user} to /home/${new_user}/data
    if lso_yn_prompt "Do you want to link ${real_data_dir} to ${symlink_dir}?"; then
        mkdir -p "${real_data_dir}" &&
            chown -R "${new_user}" "${real_data_dir}" &&
            ln -s "${real_data_dir}" "${symlink_dir}"
        lso_print_green_line "established symbolic link:"
        lso_print_green_line "actual physical directory: ${real_data_dir}, symbolic link directory: ${symlink_dir}"
        lso_print_cyan_line "${symlink_dir} --> ${real_data_dir}"
        lso_print_white_line "ll /data results as follows: "
        eval "ls -al /data | grep -C 2 -E ${new_user}$"
    else
        lso_print_white_line "abort link ${real_data_dir} to ${symlink_dir}."
        return 1
    fi
    return 0
}
