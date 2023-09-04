#!/bin/bash

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
printf "\033[32m 如果需要取消这些prompt, 请手动修改 ${HOME}/.zshrc,\n 去掉结尾的 prompt 部分 \033[0m \n"
