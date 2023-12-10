#!/bin/bash

###################################################
# description: get new user's name, and add it
#      return: 0: success | 1: fail
###################################################
function step_new_user() {
    lso_print_white_line "input new user's name: "
    read new_user

    if id -u "${new_user}" >/dev/null 2>&1; then
        lso_print_error_line "user: '${new_user}' already existed."
        lso_print_white_line "Exit Now..."
        return 1
    fi

    lso_print_green_line "user's name: ${new_user}"

    if ! lso_yn_prompt "are you sure and ready to continue?"; then
        lso_print_red_line "cancel it..."
        return 1
    fi

    # adduser --gecos "" "${new_user}"

    return 0
}
