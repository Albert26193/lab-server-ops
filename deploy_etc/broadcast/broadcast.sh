#!/bin/bash

# --------------------- greeting --------------------
function greeting {
	local user_name="$(whoami)"
	local greeting="nice to meet you, ${user_name}"
	local line_length=36
	local padding=$(((line_length - ${#greeting}) / 2))

	padding_spaces=""
	for ((i = 1; i <= padding; i++)); do
		padding_spaces+=" "
	done

	# Check if line_length and greeting length are both odd or both even
	if ((line_length % 2 == ${#greeting} % 2)); then
		right_padding_spaces="$padding_spaces"
	else
		right_padding_spaces="$padding_spaces "
	fi

	local output_string=" 
    |￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣|
    |${padding_spaces}${greeting}${right_padding_spaces}|
    |＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿|
                        \ (•◡•) / 
                         \     / 
                            ——
                          |    |
                          |_   |_ 
    "

	printf '\033[97m %s \033[0m \n' "${output_string}"
	return 0
}

# --------------------- prompt --------------------
function prompt {
	local util_path="/etc/deploy_etc/scripts/script_shell/shell_utils.sh"
	source "${util_path}"

	printf "\033[36m prompt 1: \n"
	eval "duf / /home /data"
	printf "\033[31m 大容量数据请写入 ${HOME}/data,\n 该目录已经和 /data/$(whoami) 建立软链接 \033[0m \n"

	printf "\033[36m prompt 2: \n"
	printf "\033[32m 如果需要在当前终端中访问外部网络, 请输入魔法指令:\n proxy_on 10.176.25.111 7890 \033[0m \n"

	printf "\033[36m prompt 3: \n"
	printf "\033[32m 当前你所使用的终端是ZSH, 读取的Shell配置文件为 ${HOME}/.zshrc \n 如需添加环境变量，请编辑该文件\033[0m \n"

	printf "\033[36m prompt 4: \n"
	printf "\033[32m 当前用户 $(whoami) 已经禁用 su 命令，如果需要提权，请联系管理员 \033[0m \n"

	printf "\033[36m prompt 5: \n"
	printf "\033[32m 如果需要取消这些prompt, 请手动修改 ${HOME}/.zshrc,\n 去掉结尾的 prompt 部分 \033[0m \n"
}

prompt
eval "neofetch"
greeting
