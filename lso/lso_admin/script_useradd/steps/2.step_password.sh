#!/bin/bash

###################################################
# description: get new user's name, and set passwd
#       input: $1: new_user
#      return: 0: success | 1: fail
###################################################
function step_password() {
    local new_user=$1

    # default password
    local characters='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+[]{}|;:,.<>?'
    local lso_default_password="lso-passwd-$(head /dev/urandom | tr -dc "$characters" | head -c 16)"

    if [ -z "${new_user}" ]; then
        lso_print_red_line "new_user is empty, please check it."
        return 1
    fi

    lso_print_white "the default password is:"
    lso_print_red_line "${lso_default_password}"
    echo "${new_user}:${lso_default_password}" | chpasswd
    lso_print_warning "Watch out: "
    lso_print_yellow_line "this password is random generated, only show ONCE, keep it or change it."

    if lso_yn_prompt "Do you want to change password for the ${new_user}?"; then
        lso_print_white_line "Please enter the password for the ${new_user}: "
        passwd "${new_user}"

        if [[ $? -ne 0 ]]; then
            lso_print_error_line "passwd set failed, please check it."
            return 1
        fi
    fi

    return 0
}
