#!/bin/bash

###################################################
# description: ssh key configuration
#       input: $1: new_user
#      return: 0: success | 1: fail
###################################################
function step_ssh() {
    local new_user=$1

    if [[ -z "${new_user}" ]]; then
        lso_print_red_line "new_user is empty, please check it."
        return 1
    fi

    su - "${new_user}" -c "
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh 
    ssh-keygen -t rsa -b 4096 -C "${new_user}@nisl" -f ~/.ssh/id_rsa -q -N '' &&
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys 
    chmod 600 ~/.ssh/authorized_keys"

    if [[ $? -ne 0 ]]; then
        lso_print_error_line "SSH key configuration failed"
        return 1
    else
        lso_print_green_line "SSH key configuration success"
        lso_print_white_line "you should copy private key to local."
        if lso_yn_prompt "show private key in ${LSO_COLOR_CYAN}/home/${new_user}/.ssh/id_rsa${LSO_COLOR_RESET} ?"; then
            lso_print_green_line "cat /home/${new_user}/.ssh/id_rsa"
            cat "/home/${new_user}/.ssh/id_rsa"
        else
            lso_print_white_line "you should cd /home/${new_user}/.ssh/ and copy id_rsa to local manually."
        fi
    fi

    return 0
}
