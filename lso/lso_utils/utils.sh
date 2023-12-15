#!/bin/bash

###################################################
# description: make output colorful
#          $1: input content
#      return: nothing
###################################################
LSO_COLOR_RED="\033[31m"
LSO_COLOR_GREEN="\033[32m"
LSO_COLOR_YELLOW="\033[33m"
LSO_COLOR_BLUE="\033[34m"
LSO_COLOR_MAGENTA="\033[35m"
LSO_COLOR_CYAN="\033[36m"
LSO_COLOR_WHITE="\033[97m"
LSO_COLOR_GRAY="\033[90m"
LSO_COLOR_RESET="\033[0m"
LSO_BACKGROUND_YELLOW="\033[43m"
LSO_BACKGROUND_RED="\033[41m"
LSO_BACKGROUND_GREEN="\033[42m"
LSO_COLOR_WHITE="\033[97m"
LSO_COLOR_BLACK="\033[1;30m"

lso_print_red_line() { printf "${LSO_COLOR_RED}%s${LSO_COLOR_RESET}\n" "$1"; }
lso_print_green_line() { printf "${LSO_COLOR_GREEN}%s${LSO_COLOR_RESET}\n" "$1"; }
lso_print_yellow_line() { printf "${LSO_COLOR_YELLOW}%s${LSO_COLOR_RESET}\n" "$1"; }
lso_print_blue_line() { printf "${LSO_COLOR_BLUE}%s${LSO_COLOR_RESET}\n" "$1"; }
lso_print_magenta_line() { printf "${LSO_COLOR_MAGENTA}%s${LSO_COLOR_RESET}\n" "$1"; }
lso_print_cyan_line() { printf "${LSO_COLOR_CYAN}%s${LSO_COLOR_RESET}\n" "$1"; }
lso_print_gray_line() { printf "${LSO_COLOR_WHITE}%s${LSO_COLOR_RESET}\n" "$1"; }
lso_print_white_line() { printf "${LSO_COLOR_WHITE}%s${LSO_COLOR_RESET}\n" "$1"; }

lso_print_red() { printf "${LSO_COLOR_RED}%s${LSO_COLOR_RESET} " "$1"; }
lso_print_green() { printf "${LSO_COLOR_GREEN}%s${LSO_COLOR_RESET} " "$1"; }
lso_print_yellow() { printf "${LSO_COLOR_YELLOW}%s${LSO_COLOR_RESET} " "$1"; }
lso_print_blue() { printf "${LSO_COLOR_BLUE}%s${LSO_COLOR_RESET} " "$1"; }
lso_print_magenta() { printf "${LSO_COLOR_MAGENTA}%s${LSO_COLOR_RESET} " "$1"; }
lso_print_cyan() { printf "${LSO_COLOR_CYAN}%s${LSO_COLOR_RESET} " "$1"; }
lso_print_gray() { printf "${LSO_COLOR_WHITE}%s${LSO_COLOR_RESET} " "$1"; }
lso_print_white() { printf "${LSO_COLOR_WHITE}%s${LSO_COLOR_RESET} " "$1"; }

lso_print_warning_line() { printf "${LSO_BACKGROUND_YELLOW}${LSO_COLOR_BLACK}%s${LSO_COLOR_RESET}\n" "$1"; }
lso_print_error_line() { printf "${LSO_BACKGROUND_RED}${LSO_COLOR_BLACK}%s${LSO_COLOR_RESET}\n" "$1"; }
lso_print_info_line() { printf "${LSO_BACKGROUND_GREEN}${LSO_COLOR_BLACK}%s${LSO_COLOR_RESET}\n" "$1"; }

lso_print_warning() { printf "${LSO_BACKGROUND_YELLOW}${LSO_COLOR_BLACK}%s${LSO_COLOR_RESET}" "$1"; }
lso_print_error() { printf "${LSO_BACKGROUND_RED}${LSO_COLOR_BLACK}%s${LSO_COLOR_RESET}" "$1"; }
lso_print_info() { printf "${LSO_BACKGROUND_GREEN}${LSO_COLOR_BLACK}%s${LSO_COLOR_RESET}" "$1"; }

###################################################
# description: give colorful yn_prompt
#          $1: custom prompt to print
#      return: 0: yes | 1: no
###################################################
function lso_yn_prompt() {
    local yn_input=""
    while true; do
        printf "$1 ${LSO_COLOR_CYAN}[y/n]: ${LSO_COLOR_RESET}"
        read yn_input
        case "${yn_input}" in
        [Yy]*) return 0 ;;
        [Nn]*) return 1 ;;
        *) lso_print_red_line "Please answer yes[y] or no[n]." ;;
        esac
    done
}

###################################################
# description: print step information
#          $1: current step description
#      return: nothing
###################################################
function lso_print_step() {
    local current_step=$1
    lso_print_green_line "========================================="
    lso_print_green_line "================= STEP ${current_step} ================"
    lso_print_green_line "========================================="
}

###################################################
# description: get git root path
#      return: git root path
###################################################
function lso_get_gitroot() {
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)

    if [[ -z "${git_root}" ]]; then
        lso_print_error_line "Error: git root not found, please run this script in your lso git repo."
        return 1
    fi

    echo "${git_root}"
    return 0
}

###################################################
# description: give current os judgement
#      return: Ubuntu | macOS | Debian | CentOS
###################################################
function lso_check_os() {
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        local OS=$(echo $NAME | awk '{print$1}')
    elif type lsb_release >/dev/null 2>&1; then
        local OS=$(lsb_release -si)
    elif [[ -f /etc/lsb-release ]]; then
        source /etc/lsb-release
        local OS=$DISTRIB_ID
    elif [[ -f /etc/debian_version ]]; then
        local OS=Debian
    elif [[ -f /etc/centos-release ]]; then
        local OS=CentOS
    elif [[ "$(uname -s)" == "Darwin" ]]; then
        local OS=macOS
    else
        local OS=$(uname -s)
    fi

    case $OS in
    "Ubuntu" | "Debian" | "CentOS" | "macOS")
        echo $OS
        ;;
    *)
        echo "Other"
        ;;
    esac
}

###################################################
# description: check if /opt/lab-server-ops exists
#          $1: dir to check
#      return: 0: exist | 1: not exist
###################################################
function lso_check_dir() {
    local dir="$1"
    if [[ -d "${dir}" ]]; then
        return 0
    else
        lso_print_error_line "Error: "${dir}" not exist, please INSTALL IT FIRST."
        lso_print_white_line "-----------------------------------------------------"
        lso_print_white_line "| You can install it by running:                    |"
        lso_print_white_line "|     1. cd to xxx/lab-server-ops                   |"
        lso_print_white_line "|     2. run ./deploy_opt/deploy_lso.sh             |"
        lso_print_white_line "-----------------------------------------------------"
        return 1
    fi
}

###################################################
# description: check branch name is matched with OS
#       input: branch to check
#      return: 0: exist | 1: not exist
###################################################
function lso_check_branch() {
    local current_branch="$(git branch --show-current)"        # master | linux | linux-minimum | mac-personal
    local current_os="$(lso_check_os)"                         # Ubuntu | macOS | Debian | CentOS
    local linux_release_version="$(uname -r | cut -d "." -f1)" # 5.4.0-42-generic --> 5

    if [[ ${current_os} == "macOS" ]] &&
        [[ ${current_branch} != "mac-personal" ]]; then
        lso_print_white_line "current OS: ${current_os}"
        lso_print_white_line "current Branch: ${current_branch}"
        lso_print_yellow_line "Warning: current branch is ${current_branch}, please checkout to mac-personal."
        if lso_yn_prompt "Would you like to checkout to ${LSO_COLOR_GREEN}branch:mac-personal${LSO_COLOR_RESET}?"; then
            git checkout mac-personal
            if [[ $? -ne 0 ]]; then
                lso_print_red_line "checkout to mac-personal failed, please check it."
                return 1
            else
                lso_print_green_line "checkout to mac-personal successfully."
                return 0
            fi
        else
            lso_print_red_line "abort checkout to branch:'mac-personal' ..."
            return 1
        fi
    fi

    if [[ ${current_os} != "Ubuntu" ]] && [[ ${current_os} != "Debian" ]] &&
        [[ ${current_os} != "CentOS" ]] && [[ ${current_os} != "macOS" ]]; then
        lso_print_red_line "Error: current os is NOT Support, please check it."
        lso_print_white_line "Support OS: Ubuntu | Debian | CentOS | macOS "
        return 1
    fi

    if [[ ${linux_release_version} -lt "5" ]] &&
        [[ ${current_branch} != "linux-minimum" ]]; then
        lso_print_white_line "current Release Version: "$(uname -r)""
        lso_print_yellow_line "your Linux Release Version is lower than 5, please check to linux-minimum branch."
        if lso_yn_prompt "Would you like to checkout to ${LSO_COLOR_GREEN}branch:linux-minimum${LSO_COLOR_RESET}?"; then
            git checkout linux-minimum
            if [[ $? -ne 0 ]]; then
                lso_print_red_line "checkout to 'linux-minimum' failed, please check it."
                return 1
            else
                lso_print_green_line "checkout to 'linux-minimum' successfully."
                return 0
            fi
        else
            lso_print_red_line "abort checkout to branch:'linux-minimum' ..."
            return 1
        fi
    fi

    if [[ ${linux_release_version} -ge "5" ]] &&
        [[ ${current_branch} != "linux" ]]; then
        lso_print_white_line "current Release Version: "$(uname -r)""
        lso_print_yellow_line "your Linux Release Version is higher than 5, please check to 'linux' branch."
        if lso_yn_prompt "Would you like to checkout to ${LSO_COLOR_GREEN}branch:linux${LSO_COLOR_RESET}?"; then
            git checkout linux
            if [[ $? -ne 0 ]]; then
                lso_print_red_line "checkout to 'linux' failed, please check it."
                return 1
            else
                lso_print_green_line "checkout to 'linux' successfully."
                return 0
            fi
        else
            lso_print_red_line "abort checkout to branch:'linux' ..."
            return 1
        fi
    fi

    lso_print_white_line "current OS              : ${current_os}"
    lso_print_white_line "current Release Version : "$(uname -r)""
    lso_print_white_line "current Branch          : ${current_branch}"
    lso_print_green_line "Your OS and Branch are matched 🟩, continue..."
    return 0
}

###################################################
# description: print branch rules
#      return: 0: success | 1: fail
###################################################
function lso_branch_rule() {
    lso_print_white_line "-----------------------------------------------------"
    lso_print_cyan_line "Support OS: Ubuntu | Debian | CentOS | macOS "
    lso_print_magenta_line "Current OS: $(lso_check_os)"
    lso_print_white_line "-----------------------------------------------------"
    lso_print_white "For"
    lso_print_green "MacOS(personal-use) ---> "
    lso_print_white_line "branch: mac-personal"

    lso_print_white "For"
    lso_print_green "Linux(kernel < 5): Ubuntu < 19.04 | CentOS 7/8 | Debian < 10 ---> "
    lso_print_white_line "branch: linux-minimum"

    lso_print_white "For"
    lso_print_green "Linux(kernel >= 5): Ubuntu >= 19.04 | Debian >=10 ---> "
    lso_print_white_line "branch: linux"

    lso_print_white_line "-----------------------------------------------------"
    printf "\n"

    return 0
}
