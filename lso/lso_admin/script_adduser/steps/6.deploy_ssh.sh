#!/bin/bash

#paragram: new_user
#return: none
function deploy_ssh() {
	git_root=$(git rev-parse --show-toplevel 2>/dev/null)
	source "${git_root}/utils/utils.sh"

	local new_user=$1

	su - "${new_user}" -c "
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh 
    ssh-keygen -t rsa -b 4096 -C "${new_user}@nisl.com"
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys 
    chmod 600 ~/.ssh/authorized_keys"

	utils_print_green "SSH key configuration completed"
}
