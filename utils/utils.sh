#!/bin/bash
UTILS_COLOR_RED="\033[31m"
UTILS_COLOR_GREEN="\033[32m"
UTILS_COLOR_YELLOW="\033[33m"
UTILS_COLOR_BLUE="\033[34m"
UTILS_COLOR_MAGENTA="\033[35m"
UTILS_COLOR_CYAN="\033[36m"
UTILS_COLOR_WHITE="\033[97m"
UTILS_COLOR_RESET="\033[0m"

print_red() { printf "${UTILS_COLOR_RED}%s${UTILS_COLOR_RESET}\n" "$1"; }
print_green() { printf "${UTILS_COLOR_GREEN}%s${UTILS_COLOR_RESET}\n" "$1"; }
print_yellow() { printf "${UTILS_COLOR_YELLOW}%s${UTILS_COLOR_RESET}\n" "$1"; }
print_blue() { printf "${UTILS_COLOR_BLUE}%s${UTILS_COLOR_RESET}\n" "$1"; }
print_magenta() { printf "${UTILS_COLOR_MAGENTA}%s${UTILS_COLOR_RESET}\n" "$1"; }
print_cyan() { printf "${UTILS_COLOR_CYAN}%s${UTILS_COLOR_RESET}\n" "$1"; }
print_white() { printf "${UTILS_COLOR_WHITE}%s${UTILS_COLOR_RESET}\n" "$1"; }

# YN prompt
function utils_yn_prompt() {
	local yn_input=""
	while true; do
		printf "$1 ${UTILS_COLOR_CYAN}[y/n]: ${UTILS_COLOR_RESET}"
		read yn_input
		case $yn_input in
		[Yy]*) return 0 ;;
		[Nn]*) return 1 ;;
		*) print_red "Please answer yes or no." ;;
		esac
	done
}

# print step
function utils_print_step() {
	local current_step=$1
	print_green "========================================="
	print_green "================= STEP ${current_step} ================"
	print_green "========================================="
}

# check system
function utils_check_os() {
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

	echo $OS

	case $OS in
	"Ubuntu" | "Debian" | "CentOS" | "macOS")
		return $OS
		;;
	*)
		return ""
		;;
	esac

	return ""
}
