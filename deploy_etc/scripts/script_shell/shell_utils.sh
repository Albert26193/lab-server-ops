#!/bin/bash

# define colors
MY_UTILS_COLOR_RED="\033[31m"
MY_UTILS_COLOR_GREEN="\033[32m"
MY_UTILS_COLOR_YELLOW="\033[33m"
MY_UTILS_COLOR_BLUE="\033[34m"
MY_UTILS_COLOR_MAGENTA="\033[35m"
MY_UTILS_COLOR_CYAN="\033[36m"
MY_UTILS_COLOR_LIGHT_GRAY="\033[37m"
MY_UTILS_COLOR_DARK_GRAY="\033[90m"
MY_UTILS_COLOR_LIGHT_RED="\033[91m"
MY_UTILS_COLOR_LIGHT_GREEN="\033[92m"
MY_UTILS_COLOR_RESET="\033[0m"

# YN prompt
function yn_prompt() {
    local yn_input=""
    while true; do
        printf "$1 ${MY_UTILS_COLOR_CYAN}[y/n]: ${MY_UTILS_COLOR_RESET}"
        read yn_input
        case $yn_input in
        [Yy]*) return 0 ;;
        [Nn]*) return 1 ;;
        *) echo "${MY_UTILS_COLOR_RED}Please answer yes or no.${MY_UTILS_COLOR_RESET}" ;;
        esac
    done
}
