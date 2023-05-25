#!/bin/bash
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

printf "${MY_UTILS_COLOR_CYAN} input the username plz ${MY_UTILS_COLOR_RESET}: "
read new_user

if ! id -u "${new_user}"; then
    printf "${MY_UTILS_COLOR_RED}用户 '${new_user}' 不存在。${MY_UTILS_COLOR_RESET}\n"
    exit 1
fi

# 获取脚本绝对路径
source_file_path="$(pwd)"
target_home_path="/home/${new_user}"

sudo su -c "
cp ${source_file_path}/template.zshrc ${target_home_path}/template.zshrc
cp ${source_file_path}/template.vimrc ${target_home_path}/template.vimrc
cp ${source_file_path}/zsh_download.sh ${target_home_path}/zsh_download.sh
cp ${source_file_path}/login.sh ${target_home_path}/login.sh
chown ${new_user} ${target_home_path}/template.* ${target_home_path}/zsh_download.sh ${target_home_path}/login.sh"

exit 0
