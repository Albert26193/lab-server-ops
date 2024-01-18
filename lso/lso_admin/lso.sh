#!/bin/bash

###################################################
# description: source execute files
#       input: none
#      return: 0: success | 1: fail
###################################################
function lso_admin() {
    # Check if the script is existed
    local lso_root="/opt/lab-server-ops"
    local admin_dir="${lso_root}/lso_admin"

    if [[ ! -d "${admin_dir}" ]]; then
        printf "%s\n" "${admin_dir} do not exist. Install lab-server-ops first."
        printf "%s\n" "Exit Now..."
        return 1
    fi

    local file_useradd="${admin_dir}/script_useradd/main.sh"
    local file_addzsh="${admin_dir}/script_addzsh/main.sh"

    if [[ $1 == "help" ]]; then
        echo -e "---------------------------------------------------"
        echo -e "lso_admin help:"
        echo -e "---------------------------------------------------"
        echo -e "   \033[32m lso_admin useradd \033[0m: add new user step by step"
        echo -e "   \033[32m lso_admin addzsh\033[0m  : add zsh for existed user"
        echo -e "---------------------------------------------------"
    elif [[ $1 == "useradd" ]]; then
        sudo bash "${file_useradd}"
    elif [[ $1 == "addzsh" ]]; then
        sudo bash "${file_addzsh}"
    elif [[ -z $1 ]]; then
        echo -e "---------------------------------------------------"
        echo -e "choose one of the following commands:"
        echo -e "---------------------------------------------------"
        echo -e "  \033[32m [1] lso_admin useradd \033[0m: add new user step by step"
        echo -e "  \033[32m [2] lso_admin addzsh\033[0m  : add zsh for existed user"
        echo -e "---------------------------------------------------"

        while true; do
            echo -e "\033[36minput number of the command to execute\033[0m (1-2, default 1):"
            echo -e "(input q to quit)"
            local input_number="1"
            read -r input_number
            case $input_number in
            1)
                sudo -E bash "${file_useradd}"
                break
                ;;
            2)
                sudo -E bash "${file_addzsh}"
                break
                ;;
            q)
                echo -e "\033[32m Exit Now...\033[0m\n"
                break
                ;;
            *)
                echo -e "\033[33m ${input_number} is not valid, input again\033[0m"
                ;;
            esac
        done
    else
        echo -e "\033[31m lso_admin: command not found: $1\033[0m"
        echo -e "\033[32m lso_admin help\033[0m: show help "
    fi
}
