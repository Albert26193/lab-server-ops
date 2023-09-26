#!/bin/bash

UTILS_COLOR_RED="\033[31m"
UTILS_COLOR_GREEN="\033[32m"
UTILS_COLOR_YELLOW="\033[33m"
UTILS_COLOR_BLUE="\033[34m"
UTILS_COLOR_MAGENTA="\033[35m"
UTILS_COLOR_CYAN="\033[36m"
UTILS_COLOR_WHITE="\033[97m"
UTILS_COLOR_GRAY="\033[90m"
UTILS_COLOR_RESET="\033[0m"

# colorful output
utils_print_red() { printf "${UTILS_COLOR_RED}%s${UTILS_COLOR_RESET}\n" "$1"; }
utils_print_green() { printf "${UTILS_COLOR_GREEN}%s${UTILS_COLOR_RESET}\n" "$1"; }
utils_print_yellow() { printf "${UTILS_COLOR_YELLOW}%s${UTILS_COLOR_RESET}\n" "$1"; }
utils_print_blue() { printf "${UTILS_COLOR_BLUE}%s${UTILS_COLOR_RESET}\n" "$1"; }
utils_print_magenta() { printf "${UTILS_COLOR_MAGENTA}%s${UTILS_COLOR_RESET}\n" "$1"; }
utils_print_cyan() { printf "${UTILS_COLOR_CYAN}%s${UTILS_COLOR_RESET}\n" "$1"; }
utils_print_gray() { printf "${UTILS_COLOR_WHITE}%s${UTILS_COLOR_RESET}\n" "$1"; }
utils_print_white() { printf "${UTILS_COLOR_WHITE}%s${UTILS_COLOR_RESET}\n" "$1"; }

# YN prompt
function utils_yn_prompt {
	local yn_input=""
	while true; do
		printf "$1 ${UTILS_COLOR_CYAN}[y/n]: ${UTILS_COLOR_RESET}"
		read yn_input
		case "${yn_input}" in
		[Yy]*) return 0 ;;
		[Nn]*) return 1 ;;
		*) utils_print_red "Please answer yes[y] or no[n]." ;;
		esac
	done
}

# print step
function utils_print_step {
	local current_step=$1
	utils_print_green "========================================="
	utils_print_green "================= STEP ${current_step} ================"
	utils_print_green "========================================="
}

# check system
function utils_check_os {
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

# parse yaml
function utils_parse_yaml {
	local filename="$1"
	local expression="$2"

	local yaml_array=()

	while IFS= read -r line; do
		yaml_array+=($line)
	done < <(yq "$expression" "$filename")

	echo ${yaml_array[@]}
}

# show all files
function show_all_files {
	local currentPath=$(pwd)
	local normalFileNum=$(ls -al | grep "^-" | wc -l | tr -d ' ')
	local dirFileNum=$(ls -al | grep "^d" | wc -l | tr -d ' ')
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
