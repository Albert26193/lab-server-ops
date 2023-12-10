#!/bin/bash

function deploy_visudo() {
    if lso_yn_prompt "Decide to execute visudo ?"; then
        lso_print_white_line "Continuing..."
        eval "visudo"
    else
        lso_print_red_line "Cancelled."
        return 1
    fi

    return 0
}
