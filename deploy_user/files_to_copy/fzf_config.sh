#!/bin/bash

# for fzf_jump
# change your dir here
jump_root_dirs=(
	# "${HOME}/remote-codespace"
	# "${HOME}/.config"
	# "${HOME}/.ssh"
	# "${HOME}/tmp"
	# "${HOME}/onekey_zsh"
	# "${HOME}/my_dotfile"

	# edit it with your wish
	"${HOME}"
)

jump_ignore_dirs=(
	# "node_modules"
	# ".git"
	# "dist"
	# ".cache"
	# "from-github"
	# "assets"
	# "image"
	# "images"
	# "static"
	# "data"
	# "raycast"
	# "obsidian-*"
	# "zlt-*"

	# ignore all files with '.', edit with your wish
	".*"
)
