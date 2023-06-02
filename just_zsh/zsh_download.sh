#!bin/bash
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

# first check whether zsh is installed
if [[ ! -x /bin/zsh ]]; then
    printf "${MY_UTILS_COLOR_RED} zsh is not installed, please install it first $MY_UTILS_COLOR_RESET}\n"
    exit 1
fi

proxy_ip_address="10.176.25.111"
port="7890"
export http_proxy="http://${proxy_ip_address}:${port}"
export https_proxy="http://${proxy_ip_address}:${port}"
export all_proxy="socks5://${proxy_ip_address}:${port}"

# checkout whether oh-my-zsh is installed
if [[ -d ~/.oh-my-zsh ]]; then
    printf "${MY_UTILS_COLOR_RED} oh-my-zsh is already installed, nothing to do $MY_UTILS_COLOR_RESET}\n"
    exit 1
fi

# install oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 删除不必要的所有附带文件
rm -i "${HOME}/.zshrc"
rm -i "${HOME}/.zsh_history"
rm -i "${HOME}/.shell.pre-oh-my-zsh"
rm -i "${HOME}/.zshrc.pre-oh-my-zsh"
rm -i ${HOME}/.zcompdump*

# 创建新的zshrc文件
mv "${HOME}/template.zshrc" "${HOME}/.zshrc"

# source
source "${HOME}/.zshrc"

# 设置当前文件的执行权限为400
chmod 400 "${HOME}/zsh_download.sh"
mv "${HOME}/zsh_download.sh" "${HOME}/.zsh_download.sh"
