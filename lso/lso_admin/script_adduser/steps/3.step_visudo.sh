#!/bin/bash

###################################################
# description: execute visudo
#       input: none
#      return: 0: success | 1: fail
###################################################
function deploy_visudo() {
    if lso_yn_prompt "Decide to execute visudo ?"; then
        lso_print_white_line "Continuing..."
        eval "visudo"
        if [[ $? -ne 0 ]]; then
            lso_print_red_line "visudo failed, please check it."
            return 1
        fi
    else
        lso_print_yellow_line "Cancelled."
        lso_print_white_line "No permission set for ${new_user}."
        return 0
    fi

    return 0
}
