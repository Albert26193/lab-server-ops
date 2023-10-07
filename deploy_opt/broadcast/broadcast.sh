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
	echo -e "\033[35m nice to meet you, $(whoami) 🚀\033[0m"
	echo -e "\033[1;30m\033[42m 请阅读服务器使用说明: https://docs.lab-server.cn/ \033[0m"
}

eval "neofetch"
prompt

echo ""
#greeting
