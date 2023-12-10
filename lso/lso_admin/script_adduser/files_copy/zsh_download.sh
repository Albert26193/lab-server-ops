#!bin/bash
MY_COLOR_RED="\033[31m"
MY_COLOR_RESET="\033[0m"

# first check whether zsh is installed
if [[ ! -x /bin/zsh ]]; then
    printf "${MY_COLOR_RED} zsh is not installed, please install it first $MY_COLOR_RESET}\n"
    exit 1
fi

proxy_ip_address="10.176.25.111"
port="7890"
export http_proxy="http://${proxy_ip_address}:${port}"
export https_proxy="http://${proxy_ip_address}:${port}"
export all_proxy="socks5://${proxy_ip_address}:${port}"

# checkout whether oh-my-zsh is installed
if [[ -d ~/.oh-my-zsh ]]; then
    printf "${MY_COLOR_RED} oh-my-zsh is already installed, nothing to do $MY_COLOR_RESET}\n"
    exit 1
fi

# install oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# remove files not need
rm -i "${HOME}/.zshrc"
rm -i "${HOME}/.zsh_history"
rm -i "${HOME}/.shell.pre-oh-my-zsh"
rm -i "${HOME}/.zshrc.pre-oh-my-zsh"
rm -i ${HOME}/.zcompdump*

# create new .zshrc
mv "${HOME}/template.zshrc" "${HOME}/.zshrc"
mv "${HOME}/template.vimrc" "${HOME}/.vimrc"

# source
source "${HOME}/.zshrc"

# change to 400
chmod 400 "${HOME}/zsh_download.sh"
mv "${HOME}/zsh_download.sh" "${HOME}/.zsh_download.sh"
