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
    ssh-keygen -t rsa -b 4096 -C "${new_user}@nisl.com"
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys 
    chmod 600 ~/.ssh/authorized_keys"

    if [[ $? -ne 0 ]]; then
        lso_print_error_line "SSH key configuration failed"
        return 1
    fi

    return 0
}
