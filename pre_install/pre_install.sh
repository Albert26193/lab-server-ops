#!/bin/bash

# paragrams: none
# return: none
function pre_install {
	local to_install_list=(
		"fd-find"
		"fzf"
		"duf"
		"tmux"
		"neofetch"
		"rsync"
		"zip"
		"unzip"
		"bat"
		"curl"
		"wget"
		"vim"
		"neovim"
		"git"
		"xclip"
		"tree"
		"jq"
		"yq"
	)

	for package in "${to_install_list[@]}"; do
		if ! dpkg -l | grep -q "^ii[ ]* ${package}"; then
			printf '%s\n' "${package} is not installed. Installing..."
			sudo apt-get update && sudo apt-get install -y "${package}"
		else
			printf '%s\n' "${package} is already installed."
		fi
	done
}

pre_install
