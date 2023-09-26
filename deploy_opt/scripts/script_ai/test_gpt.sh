#!/bin/bash

# long way to go
# many bugs

OPENAI_API_KEY="sb-32201db676b8d99d0bc220a2ea26f4b001e8c44b3fdd96f5"

CHAT_INIT_PROMPT="请注意，你是一个Linux领域的专家。我会请教你一些和命令有关的问题，我的主要目的是为了学习*命令的参数*.
请你按照如下格式回答问题: [[命令全称]] [[命令简介]] [[参数全称和含义]] [[简单的示例]] [[其他可选参数]]
其中, [[命令简介]]部分尽量简短,用5-10个字左右描述. 此外, [[命令参数全称和含义]], 这部分的功能应该尽量详细,它是我希望学习的重点.
譬如,我的输入是ls -a, 你的回答应该是: 
[[命令全称]]: ls ==> list
[[命令简介]]: 用来打印指定目录 [[参数全称和含义]]: -a ==> a: all, 表示输出全部的内容
[[简单的示例]]: ls -a /path/some-dir ==> 输出/path/some-dir 目录下的全部内容 
[[其他可选参数]]: 列出该命令的其他可选参数(参数条目越多越好,因为我的目的是为了学习多种不同的参数的含义).
如:
- l: long format，以长格式显示文件信息 
- a: all，显示所有文件，包括隐藏文件 
- h: human-readable，以易读的格式显示文件大小.

综上所述, 你的解答应该如同上面的格式,再次重申,我的目的是为了学习*命令的参数*,如果我给你的参数不存在,你应该明确指出该参数错误.
此外,你的解答使用中文,请严格按照上面规定的格式以及符号作答."

SYSTEM_PROMPT="$CHAT_INIT_PROMPT"

CHATGPT_CYAN_LABEL="\033[36mchatgpt \033[0m"

if [[ -z "$OPENAI_API_KEY" ]]; then
	echo "You need to set your OPENAI_API_KEY to use this script"
	echo "You can set it temporarily by running this on your terminal: export OPENAI_API_KEY=YOUR_KEY_HERE"
	exit 1
fi

end_point="https://api.openai-sb.com/v1/chat/completions"

request_to_chat() {
	local message="$1"
	escaped_system_prompt=$(escape "$SYSTEM_PROMPT")
	escaped_system_prompt+="$(man wc)"
	escaped_system_prompt="$(printf "%s" "${escaped_system_prompt}" | tr -d '\n')"
	#echo $escaped_system_prompt >&2
	escaped_command_role=$(escape "$command_role")
	curl -s -N ${end_point} \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer $OPENAI_API_KEY" \
		-d '{
            "model": "gpt-3.5-turbo",
            "messages": [
                {"role": "system", "content": "'"$escaped_system_prompt"'"},
                '"$message"'
                ],
            "max_tokens": 1024,
            "temperature": 0.7,
            "stream": true
            }' | while IFS= read -r line; do
		if [[ $line == data:* ]]; then
			json_line="${line#data: }"
			# echo $json_line
			if [[ "$json_line" != "[DONE]" ]]; then
				content=$(printf "%s" "${json_line}" | jq -r '.choices[0].delta.content // empty')
				if [[ "$content" == "" ]]; then
					content="\n"
				fi
				echo -e -n "\033[35m${content}\033[0m" | fold -s -w "$COLUMNS"
			fi
		fi
	done
	echo
}

escape() {
	echo "$1" | jq -Rrs 'tojson[1:-1]'
}

build_user_chat_message() {
	local escaped_request_prompt="$1"
	command_role="$(escape $command_role)"
	if [[ -z "$chat_message" ]]; then
		chat_message="{\"role\": \"user\", \"content\": \"$escaped_request_prompt\"}"
	else
		chat_message="$chat_message, {\"role\": \"user\", \"content\": \"$escaped_request_prompt\"}"
	fi
}

echo -e "Welcome to chatgpt. You can quit with '\033[36mexit\033[0m' or '\033[36mq\033[0m'."
running=true
while $running; do
	echo -e "\n\033[35mYOU:\033[0m"
	read -e prompt

	if [[ $prompt =~ ^(exit|q)$ ]]; then
		running=false
	else
		request_prompt=$(escape "$prompt")
		build_user_chat_message "$request_prompt"
		request_to_chat "$chat_message"
		# response_data=$(echo "$response" | jq -r '.choices[].message.content')

		# echo -e "${CHATGPT_CYAN_LABEL}${response_data}" | fold -s -w "$COLUMNS"
		#chat_message="$chat_message, {\"role\": \"assistant\", \"content\": \"$(escape "$response_data")\"}"
	fi
done
