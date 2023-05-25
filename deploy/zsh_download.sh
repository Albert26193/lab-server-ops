#!/usr/bin/bash
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
    printf "${MY_UTILS_COLOR_RED} ${}zsh is not installed, please install it first $MY_UTILS_COLOR_RESET}\n"
    exit 1
fi

#  check whether zsh is the default shell
if [[ "$(echo $SHELL)" != "/bin/zsh" ]]; then
    printf "${MY_UTILS_COLOR_RED} ${}zsh is not the default shell, please set it first $MY_UTILS_COLOR_RESET}\n"
    exit 1
fi

# checkout whether oh-my-zsh is installed
if [[ -d ~/.oh-my-zsh ]]; then
    printf "${MY_UTILS_COLOR_RED} ${}oh-my-zsh is already installed, nothing to do $MY_UTILS_COLOR_RESET}\n"
    exit 1
fi

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting