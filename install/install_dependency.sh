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

    # check branch rule
    if lso_branch_rule && lso_check_branch; then
        lso_print_green_line "branch rule check success... "
    else
        lso_print_white_line "branch rule check failed, exit now..."
        return 1
    fi

    local current_os="$(lso_check_os)"

    if [[ ${current_os} == "macOS" ]]; then
        lso_print_red_line "Redo: bash install/install.sh"
        return 1
    fi

    local common_install=(
        "tmux"
        "vim"
        "git"
        "curl"
        "wget"
        "tree"
    )

    local debian_family_install=(
        "fd-find"
        "fzf"
        "bat"
        "exa"
        "neovim"
    )

    local all_install_list=()

    # TODO: add more os to test
    case "${current_os}" in
    "Debian" | "Ubuntu" | "Raspbian")
        all_install_list=("${common_install[@]}" "${debian_family_install[@]}")
        ;;
    *)
        all_install_list=("${common_install[@]}")
        ;;
    esac

    local to_install_list=()
    for package in "${all_install_list[@]}"; do
        if ! command -v ${package} &>/dev/null; then
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
        case "${current_os}" in
        "Debian" | "Ubuntu" | "Raspbian")
            lso_print_white_line "install dependency for ${current_os}..."
            apt-get update
            apt-get install -y "${to_install_list[@]}"
            ;;
        *)
            lso_print_yellow_line "not support now, exit now..."
            return 1
            ;;
        esac
    else
        lso_print_white_line "do not install dependency, exit now..."
        return 1
    fi
}

lso_install_dependency
