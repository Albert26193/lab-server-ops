# --------------------- oh-my-zsh ---------------
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

HISTFILE="${ZSH}/cache/.zsh_history"
ZSH_COMPDUMP="${ZSH}/cache/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

source $ZSH/oh-my-zsh.sh

# --------------------- zsh --------------------
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=blue'

# --------------------- general --------------------
export TERM="xterm-256color"
user_name=$(whoami)
echo "\e[35m nice to meet you, ${user_name} 🚀\e[0m"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LS_COLORS=${LS_COLORS}:'di=01;35'

#  --------------------- alias --------------------
alias "pc"="proxychains4"
alias "nv"="nvim"
alias "tm"="tmux"
alias "lg"="lazygit"
alias "ll"="ls -l"
alias "la"="ls -al"

# --------------------- proxy --------------------
function proxy_on() {
    local proxy_ip_address="127.0.0.1"
    local port="7890"

    if [[ -n "$1" ]]; then
        proxy_ip_address="$1"
    fi

    if [[ -n "$2" ]]; then
        port="$2"
    fi

    export http_proxy="http://${proxy_ip_address}:${port}"
    export https_proxy="http://${proxy_ip_address}:${port}"
    export all_proxy="socks5://${proxy_ip_address}:${port}"
    echo -e "proxy on, ip is ${proxy_ip_address}, port is ${port}"
    curl cip.cc
}

function proxy_off() {
    unset http_proxy
    unset https_proxy
    unset all_proxy
    echo -e "proxy turn off"
    curl cip.cc
}

# --------------------- prompt --------------------
printf "\033[36m \n\n prompt 1: \n"
printf "\033[31m =================================== \033[0m \n"
printf "\033[31m          当前目录下磁盘空间为           \033[0m \n"
eval "df -h ."

printf "\033[31m =================================== \033[0m \n"
printf "\033[31m          /data 目录下磁盘空间为           \033[0m \n"
eval "df -h /data"

printf "\033[31m =================================== \033[0m \n"
printf "\033[31m 大容量数据请写入 ${HOME}/data,\n 该目录已经和 /data/$(whoami) 建立软链接 \033[0m \n"
printf "\n"

printf "\033[36m prompt 2: \n"
printf "\033[32m 如果需要在当前终端中访问外部网络, 请输入魔法指令:\n proxy_on 10.176.25.111 7890 \033[0m \n"
printf "\n"

printf "\033[36m prompt 3: \n"
printf "\033[32m 当前你所使用的终端是ZSH, 读取的Shell配置文件为 ${HOME}/.zshrc \n 如需添加环境变量，请编辑该文件\033[0m \n"
printf "\n"

printf "\033[36m prompt 4: \n"
printf "\033[32m 当前用户 $(whoami) 已经禁用 su 命令，如果需要提权，请联系管理员 \033[0m \n"
printf "\n"

printf "\033[36m prompt 5: \n"
printf "\033[32m 如果需要取消这些prompt, 请手动修改 ${HOME}/.zshrc,\n 去掉结尾的 prompt部分 \033[0m \n"
