#!/bin/bash

###################################################
# description: get new user's name, and add it
#       input: none
#      return: 0: success | 1: fail
###################################################
function step_new_user() {
    lso_print_white_line "input new user's name: "
    read new_user

    if id -u "${new_user}" >/dev/null 2>&1; then
        lso_print_warning_line "user: '${new_user}' already existed."
        lso_print_warning_line "if you delete it, all data will be lost. command: 'userdel -r ${new_user}'"
        if lso_yn_prompt "Do you want to delete ${new_user}, and create a new one?"; then
            userdel -r "${new_user}"
            if [[ $? -ne 0 ]]; then
                lso_print_error_line "userdel failed, please check it."
                return 1
            fi
        else
            lso_print_white_line "Exit Now..."
            return 1
        fi
    fi

    lso_print_green_line "user's name: ${new_user}"

    if ! lso_yn_prompt "are you sure and ready to continue?"; then
        lso_print_red_line "cancel it..."
        return 1
    fi

    useradd -m "${new_user}"

    if [[ $? -ne 0 ]]; then
        lso_print_error_line "new user add failed, please check it."
        return 1
    else
        lso_print_white_line "new user add success, ls -l /home:"
        ls -l /home
    fi

    return 0
}
