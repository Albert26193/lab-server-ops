#!/bin/bash

# paragram: $new_usr
# return: none
function deploy_password() {
    local new_user=$1

    if [ -z "${new_user}" ]; then
        lso_print_red_line "new_user is empty, please check it."
        return 1
    fi

    lso_print_white_line "Please enter the password for the ${new_user}: "
    # passwd "${new_user}"
}
