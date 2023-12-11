#!/bin/bash

###################################################
# description: add new user to groups
#       input: new_user
#      return: 0: success | 1: fail
###################################################
function step_group() {
    lso_print_white_line "Please enter group names, support continuous input, separated by spaces, such as [docker wheel sudo] etc."
    lso_print_cyan_line "If you don't want to add any group, just press Enter."

    local new_groups=""
    read -a new_groups

    local new_user=$1
    if [ -z "${new_user}" ]; then
        lso_print_red_line "new_user is empty, please check it."
        return 1
    fi

    for new_group in "${new_groups[@]}"; do
        if ! grep -q "^${new_group}:" /etc/group; then
            lso_print_red_line "Group ${new_group} does not exist, please create it manually. Skip this group."
            continue
        fi

        lso_print_white "Do you decide to add ${new_user} to the"
        lso_print_cyan "${new_group}"
        lso_print_white_line "group?"

        if ! lso_yn_prompt "Confirm?"; then
            lso_print_red_line "Cancelled."
            continue
        fi

        # Add new user and specify group
        usermod -aG "${new_group}" "${new_user}"
        lso_print_white "user ${new_user} is added to "
        lso_print_cyan "${new_group}"
        lso_print_white_line " group."
    done

    return 0
}
