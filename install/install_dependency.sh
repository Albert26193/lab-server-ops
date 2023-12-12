#!/bin/bash

###################################################
# description: install dependency
#       input: none
#      return: 0: success | 1: fail
###################################################
function lso_install_dependency() {
    # load config file
    local git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
    local util_file_path="${git_root}/utils/utils.sh"

    if [[ ! -f "${util_file_path}" ]]; then
        printf "%s\n" "${util_file_path} do not exist."
        printf "%s\n" "Exit Now..."
        return 1
    else
        source "${util_file_path}"
    fi

    # Check if the script is executed as root
    if [[ "$(id -u)" -ne 0 ]]; then
        lso_print_error_line "Please run this script as root." >&2
        return 1
    fi

    local common_install=(
        "tmux"
        "rsync"
        "zip"
        "unzip"
        "vim"
        "git"
        "curl"
        "wget"
        "tree"
    )

    local debian_ubuntu_install=(
        "fd-find"
        "fzf"
        "duf"
        "neofetch"
        "bat"
        "neovim"
        "xclip"
        "exa"
    )

    local mac_install=(
        "fd"
        "fzf"
        "duf"
        "neofetch"
        "bat"
        "neovim"
        "exa"
    )

    local current_os="$(lso_check_os)"
    local all_install_list=()

    lso_print_green_line "----------------------------------------------"
    lso_print_white_line " detected OS: ${current_os} "
    lso_print_green_line "----------------------------------------------"
    # TODO: add more os to test
    if [[ "${current_os}" == "macOS" ]]; then
        all_install_list=("${common_install[@]} ${mac_install[@]}")
    elif [[ ${current_os} == "Debian" ]]; then
        all_install_list=("${common_install[@]}" "${debian_ubuntu_install[@]}")
    elif [[ ${current_os} == "Ubuntu" ]]; then
        all_install_list=("${common_install[@]}" "${debian_ubuntu_install[@]}")
    else
        all_install_list=("${common_install[@]}")
    fi

    local to_install_list=()
    for package in "${all_install_list[@]}"; do
        if ! dpkg -l | grep -q "^ii[ ]* ${package}"; then
            lso_print_red "[ X ]"
            lso_print_red "${package}"
            lso_print_white_line "is not installed"
            to_install_list+=("${package}")
        else
            lso_print_green "[ √ ]"
            lso_print_blue "${package}"
            lso_print_white_line "is already installed."
        fi
    done

    # if all dependency installed, exit now
    if [[ ${#to_install_list[@]} -eq 0 ]]; then
        lso_print_green_line "All dependency installed, exit now..."
        return 0
    fi

    # if have dependency not installed, install it
    printf "\n"
    lso_print_yellow "🔧Here is the list of packages to install: "
    printf "${LSO_COLOR_CYAN}%s${LSO_COLOR_RESET} " "${to_install_list[@]}"
    printf "\n"
    lso_print_cyan_line "total count to install: ${#to_install_list[@]}"
    if lso_yn_prompt "Do you want to ${LSO_COLOR_GREEN}install all dependency${LSO_COLOR_RESET}?"; then
        if [[ "${current_os}" == "macOS" ]]; then
            lso_print_white_line "install dependency for macOS..."
            brew install "${to_install_list[@]}"
        elif [[ ${current_os} == "Debian" ]]; then
            lso_print_white_line "install dependency for Debian..."
            apt-get update
            apt-get install -y "${to_install_list[@]}"
        elif [[ ${current_os} == "Ubuntu" ]]; then
            lso_print_white_line "install dependency for Ubuntu..."
            apt-get update
            apt-get install -y "${to_install_list[@]}"
        else
            lso_print_yellow_line "not support now, exit now..."
            return 1
        fi
    else
        lso_print_white_line "do not install dependency, exit now..."
        return 1
    fi
}

lso_install_dependency
