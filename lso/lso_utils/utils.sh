#!/bin/bash

###################################################
# description: make output colorful
#       input: $1: input content
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
#       input: $1: custom prompt to print
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
#       input: $1: current step description
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
#       input: none
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
#      input: none
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
        echo ""
        ;;
    esac
}

###################################################
# description: check if dir exists
#       input: $1: dir to check
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
# description: show files in current directory
#       input: none
#      return: 0: success | 1: fail
###################################################
function lso_show_files {
    local currentPath=$(pwd)
    local normalFileNum=$(ls -al | tail -n +4 | grep "^-" | wc -l | tr -d ' ')
    local dirFileNum=$(ls -al | tail -n +4 | grep "^d" | wc -l | tr -d ' ')
    local totalNum=$((${normalFileNum} + ${dirFileNum}))

    printf "\033[1;30m\033[44mjump to: \033[1;30m\033[42m%s\033[0m\n" "${currentPath}"
    printf "\033[1;30m\033[44mfile count: \033[1;30m\033[42m%s\033[0m\n" "${totalNum}"
    printf "%s\n" "============="

    if [[ ${totalNum} -le 35 ]]; then
        ls -al | tail -n +2
    elif [[ ${totalNum} -ge 101 ]]; then
        echo "files in current directory is more than 100"
    else
        ls -a
    fi
}
