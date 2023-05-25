#!/bin/bash
# 一键添加新用户并分组的脚本

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
        *) printf "${MY_UTILS_COLOR_RED}Please answer yes or no.${MY_UTILS_COLOR_RESET}\n" ;;
        esac
    done
}

# 检查脚本是否以 root 用户执行
if [[ "$(id -u)" -ne 0 ]]; then
    printf "${MY_UTILS_COLOR_RED} 请使用 root 用户运行此脚本。${MY_UTILS_COLOR_RESET}" >&2
    exit 1
fi

# 获取新用户名
printf "${MY_UTILS_COLOR_GREEN}=========================================${MY_UTILS_COLOR_RESET} \n"
printf "${MY_UTILS_COLOR_GREEN}=================  STEP 1 ===============${MY_UTILS_COLOR_RESET} \n"
printf "${MY_UTILS_COLOR_GREEN}=========================================${MY_UTILS_COLOR_RESET} \n"

read -p "请输入新用户名: " new_user

# 检查用户是否已经存在
if id -u "${new_user}" >/dev/null 2>&1; then
    printf "${MY_UTILS_COLOR_RED}用户 '${new_user}' 已存在。${MY_UTILS_COLOR_RESET}\n" >&2
    exit 1
fi

printf "用户名为: ${MY_UTILS_COLOR_GREEN}%s${MY_UTILS_COLOR_RESET}\n" "${new_user}"

if yn_prompt "是否确认并继续继续?"; then
    printf "\n继续执行...\n"
else
    printf "\n ${MY_UTILS_COLOR_RED}已取消。${MY_UTILS_COLOR_RESET}\n"
    exit 1
fi

adduser ${new_user}
printf "用户已经创建: ${MY_UTILS_COLOR_GREEN}%s${MY_UTILS_COLOR_RESET}\n" "${new_user}"

# 获取新用户组名
printf "\n${MY_UTILS_COLOR_GREEN}=========================================${MY_UTILS_COLOR_RESET} \n"
printf "${MY_UTILS_COLOR_GREEN}=================  STEP 2 ===============${MY_UTILS_COLOR_RESET} \n"
printf "${MY_UTILS_COLOR_GREEN}=========================================${MY_UTILS_COLOR_RESET} \n"

printf "请输入用户组名，支持连续输入，用空格间隔，如 [docker wheel sudo] 等等\n"
read -a new_groups

for new_group in "${new_groups[@]}"; do
    # 检查组是否存在，不存在时创建该组
    if ! grep -q "^${new_group}:" /etc/group; then
        printf "组 ${MY_UTILS_COLOR_RED}%s${MY_UTILS_COLOR_RESET} 不存在，请手动创建。\n" "${new_group}"
    fi

    # 添加新用户并指定组
    usermod -aG "${new_group}" "${new_user}"

    printf "${MY_UTILS_COLOR_GREEN}是否决定将 ${new_user} 添加到 ${new_group} 组中？${MY_UTILS_COLOR_RESET}"
    if yn_prompt "确认?"; then
        printf "\n继续执行...\n"
    else
        printf "\n ${MY_UTILS_COLOR_RED}已取消。${MY_UTILS_COLOR_RESET}\n"
        exit 1
    fi
done

# 设置用户密码
printf "\n${MY_UTILS_COLOR_GREEN}=========================================${MY_UTILS_COLOR_RESET} \n"
printf "${MY_UTILS_COLOR_GREEN}=================  STEP 3 ===============${MY_UTILS_COLOR_RESET} \n"
printf "${MY_UTILS_COLOR_GREEN}=========================================${MY_UTILS_COLOR_RESET} \n"

# 设置新用户的密码
passwd "${new_user}"

echo "用户 '${new_user}' 已成功添加到组 '${new_group[@]}'。"

# 设置软链接
printf "\n${MY_UTILS_COLOR_GREEN}=========================================${MY_UTILS_COLOR_RESET} \n"
printf "${MY_UTILS_COLOR_GREEN}=================  STEP 4 ===============${MY_UTILS_COLOR_RESET} \n"
printf "${MY_UTILS_COLOR_GREEN}=========================================${MY_UTILS_COLOR_RESET} \n"

real_data_dir="/data/${new_user}"
symlink_dir="/home/${new_user}/data"

if [[ ! -d "${real_data_dir}" ]]; then
    mkdir "${real_data_dir}" && ln -s "${real_data_dir}" "${symlink_dir}"
    printf "${MY_UTILS_COLOR_CYAN} 建立符号链接，实际物理目录: ${real_data_dir}, 符号链接目录: ${symlink_dir} ${MY_UTILS_COLOR_RESET}\n"
else
    printf "${MY_UTILS_COLOR_RED} ${real_data_dir} 已经存在，请修正 ${MY_UTILS_COLOR_RESET} \n"
fi

# 设置复制相关文件
printf "\n${MY_UTILS_COLOR_GREEN}=========================================${MY_UTILS_COLOR_RESET} \n"
printf "${MY_UTILS_COLOR_GREEN}=================  STEP 5 ===============${MY_UTILS_COLOR_RESET} \n"
printf "${MY_UTILS_COLOR_GREEN}=========================================${MY_UTILS_COLOR_RESET} \n"

bash "../deploy/onekey_deploy.sh"

# 设置 SSH
printf "\n${MY_UTILS_COLOR_GREEN}=========================================${MY_UTILS_COLOR_RESET} \n"
printf "${MY_UTILS_COLOR_GREEN}=================  STEP 6 ===============${MY_UTILS_COLOR_RESET} \n"
printf "${MY_UTILS_COLOR_GREEN}=========================================${MY_UTILS_COLOR_RESET} \n"

su - "${new_user}" -c "
mkdir -p ~/.ssh
chmod 700 ~/.ssh 
ssh-keygen -t rsa -b 4096 -C "${new_user}@example.com"
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys 
chmod 600 ~/.ssh/authorized_keys"

printf "完成SSH秘钥配置\n"

exit 0
