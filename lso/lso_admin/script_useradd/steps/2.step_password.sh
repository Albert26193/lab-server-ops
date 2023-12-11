#!/bin/bash

###################################################
# description: get new user's name, and set passwd
#       input: $1: new_user
#      return: 0: success | 1: fail
###################################################
function step_password() {
    local new_user=$1

    if [ -z "${new_user}" ]; then
        lso_print_red_line "new_user is empty, please check it."
        return 1
    fi

    lso_print_white_line "Please enter the password for the ${new_user}: "
    passwd "${new_user}"

    if [[ $? -ne 0 ]]; then
        lso_print_error_line "passwd set failed, please check it."
        return 1
    fi

    return 0
}
