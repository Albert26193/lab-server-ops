#!/bin/bash

function show_all_files {
	local currentPath=$(pwd)
	local normalFileNum=$(ls -al | grep "^-" | wc -l | tr -d ' ')
	local dirFileNum=$(ls -al | grep "^d" | wc -l | tr -d ' ')
	local totalNum=$((${normalFileNum} + ${dirFileNum}))
	echo -e "\e[33m $(pwd) \e[0m"
	echo -e "\e[35m total: ${totalNum} \e[0m"

	if [[ ${totalNum} -le 15 ]]; then
		ls -al
	elif [[ ${totalNum} -ge 51 ]]; then
		echo "files in current directory is more than 50"
	else
		ls -a
	fi
}

# fuzzy jump
function jj {
	local target_file="$(fs $1 $2)"
	if [[ -d "${target_file}" ]]; then
		cd "${target_file}" && show_all_files
	elif [[ -f "${target_file}" ]]; then
		local father_dir=$(dirname "${target_file}")
		cd "${father_dir}" && show_all_files
	else
		#exit 1
		printf "%s\n" "exit fuzzy search ..."
	fi
}
